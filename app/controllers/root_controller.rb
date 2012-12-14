class RootController < ApplicationController
  def index
    render :json => Root.new, :serializer => RootSerializer, :scope => current_user
  end
end
