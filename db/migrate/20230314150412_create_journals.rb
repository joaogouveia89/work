class CreateJournals < ActiveRecord::Migration[6.1]
  def change
    create_table :journals do |t|
      t.integer :meetings
      t.integer :current_task
      t.integer :team_interaction
      t.integer :humor
      t.text :comments

      t.timestamps
    end
  end
end
