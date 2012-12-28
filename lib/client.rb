class Client
  extend Forwardable

  def_delegators :connection, :basic_auth, :get, :post, :put, :delete

  def connection
    @connection ||= Faraday.new(:url => "http://localhost:8888") do |faraday|
      faraday.request :url_encoded
      faraday.use JsonMiddleware
      faraday.adapter Faraday.default_adapter
    end
  end

  class JsonMiddleware < Faraday::Middleware
    def call(env)
      env[:request_headers]["Accept"] = "application/json"
      env[:request_headers]["Content-Type"] = "application/json"

      @app.call(env)
    end
  end
end

class Resource
  def self.load(string)
    new(JSON.load(string))
  end
end

class Links
  def initialize(link_hash)
    @links = link_hash
  end

  def fetch(link)
    link = CoreRels.rel(link) if !@links.has_key?(link)
    @links.fetch(link, {}).fetch("href", "")
  end

  def has_link?(link)
    @links.has_key?(link) || @links.has_key?(CoreRels.rel(link))
  end
end

class RootResource < Resource
  attr_accessor :links

  def initialize(attrs)
    @links = Links.new(attrs.fetch("_links"))
  end
end

class GamesResource < Resource
  extend Forwardable
  include Enumerable

  def_delegators :games, :each, :[]

  attr_accessor :games

  def initialize(attrs)
    @games = attrs.fetch("_embedded", {}).fetch("games", []).map { |game_attrs| GameResource.new(game_attrs) }
    @links = Links.new(attrs.fetch("_links"))
  end
end

class GameResource < Resource
  attr_accessor :users, :links

  def initialize(attrs)
    @users = attrs.fetch("_embedded", {}).fetch("users", []).map { |user_attrs| UserResource.new(user_attrs) }
    @links = Links.new(attrs.fetch("_links"))
  end
end

class TurnsResource < Resource
  extend Forwardable
  include Enumerable

  def_delegators :turns, :each, :[]

  attr_accessor :turns, :links

  def initialize(attrs)
    @turns = attrs.fetch("_embedded", {}).fetch("turns", []).map { |turn_attrs| TurnResource.new(turn_attrs) }
    @links = Links.new(attrs.fetch("_links"))
  end
end

class TurnResource < Resource
  attr_accessor :links, :user, :rack

  def initialize(attrs)
    @user = UserResource.new(attrs.fetch("_embedded").fetch("user"))
    @rack = attrs.fetch("rack")
    @links = Links.new(attrs.fetch("_links"))
  end
end

class UserResource < Resource
  attr_accessor :email

  def initialize(attrs)
    @email = attrs.fetch("email")
  end
end

module ClientHelper
  def client
    @client ||= Client.new
  end
end

class UserCreation < Struct.new(:attrs)
  include ClientHelper

  def perform
    client.post(user_registration_url, { :user => attrs }.to_json)
  end

  def user_registration_url
    root_resource = RootResource.load(client.get("/").body)
    root_resource.links.fetch("user-registration")
  end
end

class PlayMove < Struct.new(:client, :word, :column, :row, :direction)
  def perform
    root_resource = RootResource.load(client.get("/").body)
    games_link = root_resource.links.fetch("games")
    games_resource = GamesResource.load(client.get(games_link).body)
    game_link = games_resource.first.links.fetch("self")
    client.post(game_link, {
      :move => { :word => word, :row => row, :column => column, :direction => direction }
    }.to_json)
  end
end

def show_turns(client)
  root_resource = RootResource.load(client.get("/").body)
  games_link = root_resource.links.fetch("games")
  games_resource = GamesResource.load(client.get(games_link).body)
  game_resource = GameResource.load(client.get(games_resource.first.links.fetch("self")).body)

  turns_link = game_resource.links.fetch("turns")
  turns_resource = TurnsResource.load(client.get(turns_link).body)

  puts "There are #{turns_resource.count} turns"
  turns_resource.each do |turn|
    puts "Current player's turn - #{turn.user.email}"
    puts "Your rack - #{turn.rack}"
  end
end
