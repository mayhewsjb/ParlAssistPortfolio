class AddForeignKeysToTaggings < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :taggings, :updates
    add_foreign_key :taggings, :tags
  end
end
