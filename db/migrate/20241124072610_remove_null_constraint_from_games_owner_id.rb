# frozen_string_literal: true

class RemoveNullConstraintFromGamesOwnerId < ActiveRecord::Migration[8.0]
  def change
    change_column_null :games, :owner_id, true
  end
end
