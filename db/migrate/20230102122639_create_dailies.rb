class CreateDailies < ActiveRecord::Migration[6.1]
  def change
    create_table :dailies do |t|
      t.references :task, null: false, foreign_key: true
      t.text :notes

      t.timestamps
    end
  end
end
