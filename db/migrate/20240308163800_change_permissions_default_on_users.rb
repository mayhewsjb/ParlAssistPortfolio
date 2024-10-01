class ChangePermissionsDefaultOnUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :permissions, from: nil, to: false
  end
end
