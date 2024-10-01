class ChangePermissionsToRoleInUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :permissions, :boolean
    add_column :users, :role, :integer, default: 0
  end
end
