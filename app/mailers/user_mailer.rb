class UserMailer < ApplicationMailer
  default from: 'parkingslotfinder@gmail.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://127.0.0.1:3000'
    mail(to: @user.email, subject: 'Welcome to Parking Slot Finder App')
  end
end
