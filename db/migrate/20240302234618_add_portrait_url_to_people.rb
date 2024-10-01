class AddPortraitUrlToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :portrait_url, :string
  end
end
