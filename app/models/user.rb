require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  has_and_belongs_to_many :games

  attr_accessible :email, :password

  def self.game_order
    order("games_users.id")
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def hash
    id.hash
  end
end
