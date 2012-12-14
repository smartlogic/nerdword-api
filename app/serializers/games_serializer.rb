class GamesSerializer < ActiveModel::ArraySerializer
  include Rails.application.routes.url_helpers

  delegate :default_url_options, :to => "ActionController::Base"

  def as_json(*args)
    hash = super

    hash[:_embedded] = { :games => hash.delete("games") }
    hash[:_links] = links

    hash
  end

  private

  def links
    {
      :self => { :href => games_url }
    }
  end
end
