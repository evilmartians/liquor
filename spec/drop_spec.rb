require "spec_helper"

require "liquor/drop"

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: ':memory:',
)

ActiveRecord::Schema.define force: true do
  create_table "users", force: true do |t|
    t.string "login"
    t.string "email"
    t.string "occupation"
  end

  create_table "articles", force: true do |t|
    t.integer "user_id"
    t.string  "name"
    t.boolean "published"
  end
end

# Models

class User < ActiveRecord::Base
  include Liquor::Dropable

  has_many :articles

  scope :with_login, ->(login) { where('login = ?', login) }
end

class Article < ActiveRecord::Base
  include Liquor::Dropable

  belongs_to :user

  scope :published, where('published = ?', true)
end

dhh = User.create login: 'dhh', email: 'dhh@loudthinking.org', occupation: 'developer'
dhh.articles.create name: 'java sucks',  published: false
dhh.articles.create name: 'rails rules', published: true

me = User.create login: 'me', email: 'vassily@poupkin.org', occupation: 'developer'
me.articles.create name: 'hello world', published: true

nate = User.create login: 'xnutsive', email: 'nat@evl.ms', occupation: 'manager'

# Drops

class UserDrop < Liquor::Drop
  attributes :login, :email
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
    exec(%|{{ size(articles) }}|, articles: Article.to_drop).should == '3'
    exec(%|{{ size(articles.published) }}|, articles: Article.to_drop).should == '2'
    exec(%|{{ size(users.with_login('dhh')) }}|, users: User.to_drop).should == '1'
    exec(%|{% if article.user == null then: %}ok{% end if %}|, article: Article.new.to_drop).should == 'ok'
  end

  it "should support generic find_by" do
    exec(%|{{ users.find_by(login: "dhh").email }}|, users: User.to_drop).should == 'dhh@loudthinking.org'
    exec(%|{{ users.find_by(email: "vassily@poupkin.org").login }}|, users: User.to_drop).should == 'me'
  end

  it "should support generic find_all_by and return a tuple" do
    exec(%|{{ users.find_all_by(occupation: "developer").count }}|, users: User.to_drop).should == '2'
    exec(%|{{ users.find_all_by(occupation: "manager").count }}|, users: User.to_drop).should == '1'
  end


  it "should return intact source" do
    @dhh.to_drop.source.should == @dhh
  end

  it "should support equality" do
    (@dhh.to_drop == @dhh.to_drop).should == true
  end
end
