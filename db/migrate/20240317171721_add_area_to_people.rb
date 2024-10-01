class AddAreaToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :area, :float
  end
end
