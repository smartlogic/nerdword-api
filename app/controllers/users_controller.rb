class UsersController < ApplicationController
  skip_before_filter :authorize_user!

  def create
    User.create(params[:user])

    head 204
  end
end
