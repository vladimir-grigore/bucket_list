# frozen_string_literal: true

# Migration
class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :name
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.boolean :public
      t.datetime :deadline

      t.timestamps
    end
  end
end
