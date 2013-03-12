#!/usr/bin/env ruby
require File.expand_path('../../config/environment',  __FILE__)
require 'capybara/server'
require 'forwardable'
require 'client'
require 'nerdword/not_random'
require 'nerdword/direction'
require 'nerdword/move'
require 'nerdword/position'

Tile.send(:remove_const, :REGULAR_DISTRIBUTION)
Tile::REGULAR_DISTRIBUTION = %w{
  G I N O O T T
  A E O Q R S U
  A I M N O T U
  A E F G I T O
  D E E I L P V
  A A B L Y
  A A D D O
  E E R
  A C E H U
  F I P R W
  M O U
  E I J L N
  E S
  D I N O
  H R Z
  A C E K T T W
  f I S
  a N B
  E G N X
  L R V
  R S Y
  E I
}

class Nerdword::NotRandom
  def initialize(seed = 0)
  end
end

Rails.application.randomness = Nerdword::NotRandom

Capybara.server do |app, port|
  require 'rack/handler/thin'
  Thin::Logging.silent = true
  Rack::Handler::Thin.run(app, :Port => port)
end

server = Capybara::Server.new(Rails.application, 8888)
server.boot

puts "Server booted"

player_1_email = "player-#{SecureRandom.hex(10)}@example.com"
player_2_email = "player-#{SecureRandom.hex(10)}@example.com"
password = "password"

# Create player
UserCreation.new(:email => player_1_email, :password => password).perform

player_1_client = Client.new
player_1_client.basic_auth(player_1_email, password)


# Create player
UserCreation.new(:email => player_2_email, :password => password).perform

player_2_client = Client.new
player_2_client.basic_auth(player_2_email, password)


# Create the game
root_resource = RootResource.load(player_1_client.get("/").body)
games_link = root_resource.links.fetch("games")
player_1_client.post(games_link, { :players => [player_2_email] }.to_json)


# View the game
root_resource = RootResource.load(player_1_client.get("/").body)
games_link = root_resource.links.fetch("games")
games_resource = GamesResource.load(player_1_client.get(games_link).body)

puts "Player 1 has #{games_resource.count} games"
games_resource.each do |game|
  puts
  game.users.each do |user|
    puts "* #{user.email}"
  end
  puts
end

# View the game
root_resource = RootResource.load(player_2_client.get("/").body)
games_link = root_resource.links.fetch("games")
games_resource = GamesResource.load(player_2_client.get(games_link).body)

puts "Player 2 has #{games_resource.count} games"
games_resource.each do |game|
  puts
  game.users.each do |user|
    puts "* #{user.email}"
  end
  puts
end

moves = [
  Nerdword::Move.new("TOOTING", Nerdword::Position.new(3, 7), Nerdword::Direction::HORIZONTAL),
  Nerdword::Move.new("EQUATORS", Nerdword::Position.new(3, 3), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("MOUNTAIN", Nerdword::Position.new(8, 4), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("FOGIE", Nerdword::Position.new(7, 0), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("LIVED", Nerdword::Position.new(7, 10), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("BAA", Nerdword::Position.new(2, 8), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("DOPED", Nerdword::Position.new(9, 1), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("RELAY", Nerdword::Position.new(1, 5), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("AHA", Nerdword::Position.new(0, 5), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("PEWIT", Nerdword::Position.new(4, 10), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("QUA", Nerdword::Position.new(3, 4), Nerdword::Direction::HORIZONTAL),
  Nerdword::Move.new("FLINT", Nerdword::Position.new(0, 14), Nerdword::Direction::HORIZONTAL),
  Nerdword::Move.new("MEOW", Nerdword::Position.new(1, 12), Nerdword::Direction::HORIZONTAL),
  Nerdword::Move.new("REJOINED", Nerdword::Position.new(6, 13), Nerdword::Direction::HORIZONTAL),
  Nerdword::Move.new("CHEZ", Nerdword::Position.new(12, 11), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("WACKO", Nerdword::Position.new(5, 3), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("fUZES", Nerdword::Position.new(10, 14), Nerdword::Direction::HORIZONTAL),
  Nerdword::Move.new("BEN", Nerdword::Position.new(9, 9), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("SEX", Nerdword::Position.new(10, 4), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("VAR", Nerdword::Position.new(10, 8), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("GYRO", Nerdword::Position.new(4, 1), Nerdword::Direction::HORIZONTAL),
  Nerdword::Move.new("DEaLT", Nerdword::Position.new(9, 1), Nerdword::Direction::HORIZONTAL),
  Nerdword::Move.new("SIR", Nerdword::Position.new(11, 5), Nerdword::Direction::VERTICAL),
  Nerdword::Move.new("IT", Nerdword::Position.new(13, 0), Nerdword::Direction::HORIZONTAL)
]

clients = [player_1_client, player_2_client]

moves.each_with_index do |move, index|
  player = index % 2
  client = clients[index % 2]

  puts
  puts
  puts "Player #{player}"
  show_turns(client)

  puts "Player #{player} move"
  puts "- Playing #{move.word}"
  PlayMove.new(client, move.word, move.position.col, move.position.row, move.direction).perform
end
