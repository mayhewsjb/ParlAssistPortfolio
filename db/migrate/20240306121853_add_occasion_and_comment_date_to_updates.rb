class AddOccasionAndCommentDateToUpdates < ActiveRecord::Migration[7.1]
  def change
    add_column :updates, :occasion, :string
    add_column :updates, :comment_date, :date
  end
end
