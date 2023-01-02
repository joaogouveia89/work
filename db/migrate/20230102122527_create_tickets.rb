class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.string :name
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
