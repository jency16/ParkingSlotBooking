class EntryPoint < ApplicationRecord
  has_many :slot_bookings, dependent: :destroy
end
