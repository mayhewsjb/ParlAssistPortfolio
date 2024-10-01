class AddConstituencyToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :constituency, :string
  end
end
