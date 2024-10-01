class CreateConstituencies < ActiveRecord::Migration[7.1]
  def change
    create_table :constituencies do |t|
      t.integer :api_id
      t.string :name
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
