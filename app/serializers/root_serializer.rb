class RootSerializer < ActiveModel::Serializer
  attribute :_links

  def _links
    {
      :self => { :href => root_url }
    }
  end
end
