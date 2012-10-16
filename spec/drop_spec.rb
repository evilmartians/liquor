require "spec_helper"

require "sqlite3"
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
  scope :with_id,    ->(id)    { where('id = ?', id) }
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
  attributes :id, :login, :email
  scopes :with_login, :with_id

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

  it "should allow iterating" do
    expect {
      exec(%|{% for user in: users do: %}{{ user.id }}{% end for %}|, users: User.to_drop)
    }.not_to raise_error
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
    exec(%|{{ users.find_by(id: user).email }}|, users: User.to_drop, user: @dhh.to_drop).should == 'dhh@loudthinking.org'
  end

  it "should support generic find_all_by and return a tuple" do
    exec(%|{{ size(users.find_all_by(occupation: "developer")) }}|, users: User.to_drop).should == '2'
    exec(%|{{ size(users.find_all_by(occupation: "manager")) }}|, users: User.to_drop).should == '1'
  end

  it "should support reversing" do
    ltr = exec(%|{% for user in: users do: %}{{ user.id }}{% end for %}|, users: User.to_drop)
    rtl = exec(%|{% for user in: users.reverse do: %}{{ user.id }}{% end for %}|, users: User.to_drop)
    ltr.should == rtl.reverse
  end

  it "should provide [] access to the elements, returned by find_all_by function" do
    exec(%|
      {% assign found_users = users.find_all_by(occupation: "developer") %}
      {{ found_users[0].login }}
    |, users: User.to_drop).strip.should == 'dhh'
  end

  it "should accept scope returned by find_all_by in for statements" do
    exec(%|
      {% for user in: users.find_all_by(occupation: "developer") do: %}
        {{ user.login }}
      {% end for %}
    |, users: User.to_drop).split.should == %w[dhh me]
  end

  it "should accept scope returned by find_all into empty() function" do
    exec(%|{% if !is_empty(users.find_all_by(occupation: "developer")) then: %}it works{%end if%}|, users: User.to_drop).should == "it works"
    exec(%|{% if is_empty(users.find_all_by(occupation: "idiot")) then: %}it works{% end if%}|, users: User.to_drop).should == "it works"
  end

  it "should support #pluck" do
    exec(%!{{ users.pluck('login') | join with: ', ' }}!, users: User.to_drop).should == 'dhh, me, xnutsive'
  end

  it "should export model name from Drop and Drop::Scope" do
    exec(%!{{ users.entity }}!, users: User.to_drop).should == 'User'
    exec(%!{{ users.first.entity }}!, users: User.to_drop).should == 'User'
  end

  it "should return intact source" do
    @dhh.to_drop.source.should == @dhh
  end

  it "should support equality" do
    (@dhh.to_drop == @dhh.to_drop).should == true
    (@dhh.to_drop.eql? @dhh.to_drop).should == true
  end

  it "should support include?" do
    lib = Module.new do
      include Liquor::Library

      function "check", {
                  mandatory_named_args: {
                    collection: :any,
                    element:    :any,
                  }
                } do |arg, kw|
        kw[:collection].include? kw[:element]
      end
    end

    compiler = Liquor::Compiler.new
    lib.export compiler
    code = compiler.compile!(parse(%|
      {% if check(collection: collection element: element) then: %}
        yes
      {% end if %}
    |, compiler), [:collection, :element])

    code.call(collection: User.to_drop, element: @dhh.to_drop).
        strip.should == 'yes'
    code.call(collection: User.to_drop, element: User.new.to_drop).
        strip.should == ''
  end

  it "should support uniq'ing" do
    @dhh.to_drop.hash.should == @dhh.to_drop.hash
    [@me, @dhh, @dhh].map(&:to_drop).uniq.size.should == 2
  end

  it "should unwrap arguments to derivative scopes" do
    Liquor::Drop.unwrap_scope_arguments([ @me.to_drop ]).
        should == [@me.id]
    Liquor::Drop.unwrap_scope_arguments([ [@me.to_drop, @dhh.to_drop] ]).
        should ==  [ [@me.id, @dhh.id] ]
    Liquor::Drop.unwrap_scope_arguments([ 1, { a: @me.to_drop, b: @dhh.to_drop } ]).
        should == [ 1, { a: @me.id, b: @dhh.id } ]
    exec('{{ scope.with_id(obj).first.login }}', scope: User.to_drop, obj: @me.to_drop).
        should == @me.login
  end
end
