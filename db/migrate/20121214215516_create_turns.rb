class CreateTurns < ActiveRecord::Migration
  def change
    create_table :turns do |t|
      t.integer :game_id
      t.integer :user_id
      t.string :move, :default => ""

      t.timestamp
    end
  end
end
