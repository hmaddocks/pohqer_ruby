class CreateRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :rounds do |t|
      t.references :game, null: false, foreign_key: true
      t.boolean :finished, default: false
      t.string :story_title

      t.timestamps
    end
  end
end
