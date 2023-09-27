class CreateEntryPoints < ActiveRecord::Migration[7.0]
  def change
    create_table :entry_points do |t|
      t.string :name
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
