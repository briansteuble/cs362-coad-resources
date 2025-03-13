require 'rails_helper'

RSpec.describe 'Logging in', type: :feature do
  scenario 'User logs in with valid credentials' do
    user = User.create!(email: 'valid@example.com', password: 'password')
    user.confirm

    visit new_user_session_path

    fill_in 'Email', with: 'valid@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'  

    expect(page).to have_content('Signed in successfully').or have_current_path(dashboard_path)
  end

  scenario 'User logs in with invalid credentials' do
    visit new_user_session_path

    fill_in 'Email', with: 'wrong@example.com'
    fill_in 'Password', with: 'invalid'
    click_button 'Sign in'

    expect(page).to have_content('Invalid Email or password')
    expect(page).to have_current_path(new_user_session_path)
  end
end
