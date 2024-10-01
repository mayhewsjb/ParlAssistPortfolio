class ChangeConstituencyIdNullConstraintInPeople < ActiveRecord::Migration[7.1]
  def change
    change_column_null :people, :constituency_id, true
  end
end
