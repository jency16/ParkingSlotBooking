class Slot < ApplicationRecord
  has_one :slot_booking, dependent: :destroy
end
