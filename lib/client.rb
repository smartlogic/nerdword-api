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

  # Fetch out links not worrying about custom rels
  #
  # @param [String] link relation
  #
  # @return [String] href
  def fetch(link)
    link = CoreRels.rel(link) if !@links.has_key?(link)
    @links.fetch(link, {}).fetch("href", "")
  end

  # Check if a link rel is included
  #
  # @param [String] link relation
  #
  # @return [Boolean]
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
