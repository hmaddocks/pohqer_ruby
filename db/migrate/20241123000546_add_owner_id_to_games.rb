class AddOwnerIdToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :owner_id, :integer
    add_index :games, :owner_id
    add_foreign_key :games, :players, column: :owner_id

    # Data migration: Set owner_id based on owner_name
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE games
          SET owner_id = (
            SELECT id FROM players
            WHERE players.game_id = games.id
            AND players.name = games.owner_name
            LIMIT 1
          )
        SQL
      end
    end

    # Make owner_id not nullable after data migration
    change_column_null :games, :owner_id, false
  end
end
