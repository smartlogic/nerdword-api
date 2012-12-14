class RootController < ApplicationController
  def index
    render :json => Root.new, :serializer => RootSerializer
  end
end
