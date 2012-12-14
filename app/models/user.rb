require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  attr_accessible :email, :password

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
