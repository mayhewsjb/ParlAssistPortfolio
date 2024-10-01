class RemoveUserIdFromPeople < ActiveRecord::Migration[7.1]
  def change
    remove_reference :people, :user, index: true, foreign_key: true
  end
end
