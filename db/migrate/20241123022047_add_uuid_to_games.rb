# frozen_string_literal: true

class AddUuidToGames < ActiveRecord::Migration[8.0]
  def up
    add_column :games, :uuid, :string
    add_index :games, :uuid, unique: true

    # Generate UUIDs for existing records
    Game.reset_column_information
    Game.find_each do |game|
      game.update_column(:uuid, SecureRandom.uuid)
    end

    # Make uuid not nullable after populating data
    change_column_null :games, :uuid, false
  end

  def down
    remove_column :games, :uuid
  end
end
