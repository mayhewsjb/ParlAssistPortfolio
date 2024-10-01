class RenameUpdateIdToRelatedUpdateIdInTaggings < ActiveRecord::Migration[7.1]
  def change
    rename_column :taggings, :update_id, :related_update_id
  end
end
