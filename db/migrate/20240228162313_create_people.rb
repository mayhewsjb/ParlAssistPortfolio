class CreatePeople < ActiveRecord::Migration[7.1]
  def change
    create_table :people do |t|
      t.string :name
      t.integer :party
      t.string :constituency
      t.string :role
      t.text :notes

      t.timestamps
    end
  end
end
