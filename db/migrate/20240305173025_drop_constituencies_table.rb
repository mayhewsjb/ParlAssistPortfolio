class DropConstituenciesTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :constituencies
  end

  def down
    create_table :constituencies do |t|
      # Add back the columns that were in the constituencies table
      t.string :name
      t.integer :api_id
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
