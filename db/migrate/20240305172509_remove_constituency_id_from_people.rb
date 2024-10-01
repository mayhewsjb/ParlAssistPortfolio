class RemoveConstituencyIdFromPeople < ActiveRecord::Migration[7.1]
  def change
    remove_column :people, :constituency_id, :integer
  end
end
