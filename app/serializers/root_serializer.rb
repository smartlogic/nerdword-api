class RootSerializer < ActiveModel::Serializer
  attribute :_links

  def _links
    base_links = {
      :self => { :href => root_url }
    }

    if scope
      base_links[CoreRels.rel("games")] = { :href => games_url }
    end

    base_links
  end
end
