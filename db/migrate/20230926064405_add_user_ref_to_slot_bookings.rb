class AddUserRefToSlotBookings < ActiveRecord::Migration[7.0]
  def change
    add_reference :slot_bookings, :user, null: false, foreign_key: true
  end
end
