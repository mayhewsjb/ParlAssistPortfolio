class CreateTaggings < ActiveRecord::Migration[7.1]
  def change
    create_table :taggings do |t|
      t.integer :update_id, null: false
      t.integer :tag_id, null: false
      t.timestamps
    end

    add_index :taggings, :update_id
    add_index :taggings, :tag_id
  end
end
