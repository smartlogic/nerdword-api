class CreateTurns < ActiveRecord::Migration
  def change
    create_table :turns do |t|
      t.integer :game_id
      t.string :move

      t.timestamp
    end
  end
end
