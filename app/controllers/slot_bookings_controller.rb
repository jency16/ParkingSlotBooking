class SlotBookingsController < ApplicationController
  before_action :set_entry_points, only: [:new, :create]
  before_action :set_slot, only: [:show, :cancel]

  def index
  end

  def new
    @slot_booking = SlotBooking.new
  end

  def show
  end

  def create
    @slot_booking = SlotBooking.new(slot_booking_params)
    @slot_booking.entry_time = Time.now
    @slot_booking.user_id = current_user.id

    if @slot_booking.entry_point.present?
      nearest_slot = find_nearest_available_slot(@slot_booking.entry_point)

      if nearest_slot
        @slot_booking.slot = nearest_slot
        nearest_slot.update(occupied: true)
        respond_to do |format|
          if @slot_booking.save
            format.html { redirect_to slot_booking_path(@slot_booking), notice: "Slot booked successfully! Your nearest slot is #{nearest_slot.number}." }
          else
            format.html { render :new, status: :unprocessable_entity, alert: "Failed to book the slot" }
          end
        end
      else
        render :new, status: :unprocessable_entity, alert: "No slots available at the moment"
      end
    else
      render :new, alert: "Entry point must present"
    end
  end

  def cancel
    respond_to do |format|
      if @slot_booking.cancel
        format.html { redirect_to my_bookings_slot_bookings_path, notice: "Slot booking has been canceled successfully." }
      else
        format.html { redirect_to my_bookings_slot_bookings_path, alert: "Unable to cancel the slot booking." }
      end
    end
  end

  def used_slots
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @pagy, @slot_bookings = pagy(SlotBooking.includes(:slot).used_on_date(@date), items: 5)
  end

  def allocation_history
    @vehicle_number = params[:vehicle_number]
    @pagy, @slot_bookings = pagy(SlotBooking.includes(:slot).history(@vehicle_number))
  end

  def first_entry
    @pagy, @slot_bookings = pagy(SlotBooking.select("MIN(entry_time) AS first_entry_time, vehicle_registration_number").group(:vehicle_registration_number), items: 8)
  end

  def my_bookings
    @pagy, @slot_bookings = pagy(SlotBooking.includes(:slot).where(user_id: current_user.id))
  end


  private

  def set_entry_points
    @entry_points = EntryPoint.all
  end

  def set_slot
    @slot_booking = SlotBooking.find(params[:id])
  end

  def slot_booking_params
    params.require(:slot_booking).permit(:entry_point_id, :vehicle_registration_number)
  end

  def find_nearest_available_slot(entry_point)
    available_slots = Slot.where(occupied: false)
    nearest_slot = nil
    nearest_distance = nil

    available_slots.each do |slot|
      distance = Geocoder::Calculations.distance_between(
        [entry_point.latitude, entry_point.longitude],
        [slot.latitude, slot.longitude]
      )

      if nearest_distance.nil? || distance < nearest_distance
        nearest_slot = slot
        nearest_distance = distance
      end
    end

    nearest_slot
  end

end
