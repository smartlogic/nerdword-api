class CreateTurns < ActiveRecord::Migration
  def change
    create_table :turns do |t|
      t.integer :game_id
      t.integer :user_id

      t.string :word
      t.integer :col
      t.integer :row
      t.string :direction

      t.timestamp
    end
  end
end
