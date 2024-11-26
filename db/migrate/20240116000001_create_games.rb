# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.string :owner_name, null: false
      t.string :title

      t.timestamps
    end
  end
end
