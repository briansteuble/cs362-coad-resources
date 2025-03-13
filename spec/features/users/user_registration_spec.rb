require 'rails_helper'

RSpec.describe 'User registration', type: :feature do
  scenario 'Visitor signs up with valid info' do
    visit new_user_registration_path
    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'
    click_button 'Sign up'
  
    expect(page).to have_content("A message with a confirmation link has been sent")
  end
  

  scenario 'Visitor signs up with mismatched password => sees error' do
    visit new_user_registration_path

    fill_in 'Email', with: 'baduser@example.com'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'differentpassword'
    click_button 'Sign up'

    expect(page).to have_content("doesn't match")
    expect(page).to have_current_path(user_registration_path)
  end
end
