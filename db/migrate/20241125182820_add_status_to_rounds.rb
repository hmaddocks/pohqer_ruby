class AddStatusToRounds < ActiveRecord::Migration[8.0]
  def change
    add_column :rounds, :status, :integer, default: 0, null: false
    remove_column :rounds, :finished, :boolean
  end
end
