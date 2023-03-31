class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.references :ticket
      t.string :label
      t.string :url

      t.timestamps
    end
  end
end
