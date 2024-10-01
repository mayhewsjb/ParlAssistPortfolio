class AddDetailsToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :member_id, :integer
    add_column :people, :membership_start_date, :datetime
    add_column :people, :membership_end_date, :datetime, null: true
    add_column :people, :active_status, :boolean
  end
end
