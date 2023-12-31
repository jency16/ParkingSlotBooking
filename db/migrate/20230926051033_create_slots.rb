class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots do |t|
      t.integer :number
      t.float :latitude
      t.float :longitude
      t.boolean :occupied

      t.timestamps
    end
  end
end
