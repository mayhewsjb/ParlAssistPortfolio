class AddConstituencyReferenceToPeople < ActiveRecord::Migration[7.1]
  def change
    add_reference :people, :constituency, null: false, foreign_key: true
  end
end
