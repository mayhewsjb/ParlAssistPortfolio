class RemoveConstituencyFromPeople < ActiveRecord::Migration[7.1]
  def change
    remove_column :people, :constituency, :string
  end
end
