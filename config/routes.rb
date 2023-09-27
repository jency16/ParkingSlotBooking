Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :slot_bookings do
    member do
      patch 'cancel'
    end
    collection do
      get 'allocation_history'
      get 'first_entry'
      get 'my_bookings'
      get 'used_slots'
    end
  end

  root to: 'slot_bookings#index'
end
