class AddScoreToRounds < ActiveRecord::Migration[8.0]
  def change
    add_column :rounds, :score, :integer
  end
end
