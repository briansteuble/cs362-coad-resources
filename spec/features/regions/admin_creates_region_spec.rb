require 'rails_helper'

RSpec.describe 'Creating a Region', type: :feature do
  scenario 'Admin user creates a region successfully' do
    admin = User.create!(email: 'admin@example.com', password: 'password', role: :admin)
    admin.confirm

    visit new_user_session_path
    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit regions_path
    click_link 'Add Region'

    fill_in 'Name', with: 'My New Region'
    click_button 'Add Region'

    expect(page).to have_current_path(regions_path)
    expect(page).to have_content('Region successfully created.')
    expect(Region.find_by(name: 'My New Region')).not_to be_nil
  end

  scenario 'Non-admin user attempts to create a region => redirect' do
    user = User.create!(email: 'user@example.com', password: 'password')
    user.confirm

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit regions_path

    visit new_region_path

    expect(page).to have_current_path(dashboard_path),
      "Expected non-admin user to be redirected to dashboard, but wasn't."
  end
end
