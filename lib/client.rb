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
  attr_accessor :games

  def initialize(attrs)
    @games = attrs.fetch("_embedded", {}).fetch("games", []).map { |game_attrs| GameResource.new(game_attrs) }
    @links = Links.new(attrs.fetch("_links"))
  end
end

class GameResource < Resource
  attr_accessor :users

  def initialize(attrs)
    @users = attrs.fetch("_embedded", {}).fetch("users", []).map { |user_attrs| UserResource.new(user_attrs) }
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
