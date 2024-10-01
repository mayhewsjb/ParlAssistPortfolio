class AddMajorityToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :majority, :integer
  end
end
