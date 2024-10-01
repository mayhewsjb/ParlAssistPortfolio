class CreateGovernmentPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :government_posts do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.text :additional_info
      t.string :additional_info_link
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
