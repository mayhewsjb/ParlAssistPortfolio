class CreateUpdates < ActiveRecord::Migration[7.1]
  def change
    create_table :updates do |t|
      t.text :content
      t.references :person, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
