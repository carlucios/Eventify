# frozen_string_literal: true

class RemoveFollowedIdFromFollows < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :follows, column: :followed_id
    remove_index :follows, :followed_id
    remove_column :follows, :followed_id
  end
end
