class AddEmailToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :email, :string
  end
end
