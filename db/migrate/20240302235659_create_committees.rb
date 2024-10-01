class CreateCommittees < ActiveRecord::Migration[7.1]
  def change
    create_table :committees do |t|
      t.string :name
      t.integer :api_committee_id
      t.text :additional_info
      t.string :additional_info_link

      t.timestamps
    end
  end
end
