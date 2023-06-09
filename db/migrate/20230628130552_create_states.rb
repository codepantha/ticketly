class CreateStates < ActiveRecord::Migration[6.1]
  def change
    create_table :states do |t|
      t.string :name
      t.string :color
    end

    add_reference :tickets, :state, index: true, foreign_key: true
    add_reference :comments, :state, foreign_Key: true
  end
end
