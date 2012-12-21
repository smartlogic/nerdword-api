class AddRandomSeedToGames < ActiveRecord::Migration
  def change
    add_column :games, :random_seed, :string
  end
end
