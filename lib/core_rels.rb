# A utility class for converting a rel to an app specific rel
class CoreRels
  # Append http://nerdwordapp.com/rels/ before a custom rel
  def self.rel(rel)
    "http://nerdwordapp.com/rels/#{rel}"
  end
end
