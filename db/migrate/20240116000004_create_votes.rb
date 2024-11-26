# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.references :player, null: false, foreign_key: true
      t.references :round, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end

    add_index :votes, %i[player_id round_id], unique: true
  end
end
