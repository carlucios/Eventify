# frozen_string_literal: true

class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }
      t.references :followable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
