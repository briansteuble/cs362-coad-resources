require 'rails_helper'

RSpec.describe 'Users index page', type: :feature do
  scenario 'Admin sees a list of users with their emails' do
    admin = User.create!(email: 'admin@example.com', password: 'password', role: :admin)
    admin.confirm

    user1 = User.create!(email: 'user1@example.com', password: 'password')
    user1.confirm
    user2 = User.create!(email: 'user2@example.com', password: 'password')
    user2.confirm

    visit new_user_session_path
    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in' 

    visit users_path

    expect(page).to have_content('user1@example.com')
    expect(page).to have_content('user2@example.com')
  end
end
