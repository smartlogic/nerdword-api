class TurnsSerializer < ActiveModel::ArraySerializer
  include Rails.application.routes.url_helpers

  delegate :default_url_options, :to => "ActionController::Base"

  def as_json(*args)
    hash = super

    hash[:_embedded] = { :turns => hash.delete("turns") }
    hash[:_links] = { 
      CoreRels.rel("game") => { :href => game_url(game) },
      :self => { :href => game_turns_url(game) }
    }

    hash
  end

  private

  def game
    @options[:game]
  end
end
