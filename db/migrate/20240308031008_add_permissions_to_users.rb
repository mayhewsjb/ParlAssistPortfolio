class AddPermissionsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :permissions, :boolean
  end
end
