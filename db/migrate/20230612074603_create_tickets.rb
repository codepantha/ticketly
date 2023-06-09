# frozen_string_literal: true

class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.string :name
      t.string :description
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
