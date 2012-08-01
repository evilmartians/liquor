require "spec_helper"

require "liquor/drop"

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: ':memory:',
)

ActiveRecord::Schema.define force: true do
  create_table "users", force: true do |t|
    t.string "login"
  end

  create_table "articles", force: true do |t|
    t.integer "user_id"
    t.string  "name"
    t.boolean "published"
  end
end

# Models

class User < ActiveRecord::Base
  include Liquor::Droppable

  has_many :articles

  scope :with_login, ->(login) { where('login = ?', login) }
end

class Article < ActiveRecord::Base
  include Liquor::Droppable

  belongs_to :user

  scope :published, where('published = ?', true)
end

dhh = User.create login: 'dhh'
dhh.articles.create name: 'java sucks',  published: false
dhh.articles.create name: 'rails rules', published: true

me = User.create login: 'me'
me.articles.create name: 'hello world', published: true

# Drops

class UserDrop < Liquor::Drop
  attributes :login
  scopes :with_login

  has_many :articles, scope: [ :published ]
end

class ArticleDrop < Liquor::Drop
  attributes :name, :published
  scopes :published

  belongs_to :user
end

describe Liquor::Drop do
  before do
    @me = User.find_by_login 'me'
    @dhh = User.find_by_login 'dhh'
  end

  it "should export attributes" do
    strukt = Struct.new(:a, :b)
    klass = Class.new(Liquor::Drop) do
      attributes :a, :b
    end

    datum = strukt.new(1, "hello")
    drop  = klass.new(datum)

    exec('{{ drop.a }} {{ drop.b }}', drop: drop).should == '1 hello'
    expect { exec('{{ drop.c }}') }.to raise_error
  end

  it "should walk relations and stuff" do
    exec('{{ user.login }}', user: @dhh.to_drop).should == 'dhh'
    exec(%|
      {% for article in: user.articles do: %}
        {{ article.name }}
      {% end for %}
    |, user: @dhh.to_drop).strip.should == 'rails rules'
    exec(%|{{ articles.count }}|, articles: Article.to_drop).should == '3'
    exec(%|{{ articles.published.count }}|, articles: Article.to_drop).should == '2'
    exec(%|{{ users.with_login('dhh').count }}|, users: User.to_drop).should == '1'
  end
end