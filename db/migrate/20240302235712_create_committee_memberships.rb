class CreateCommitteeMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :committee_memberships do |t|
      t.references :person, null: false, foreign_key: true
      t.references :committee, null: false, foreign_key: true
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
