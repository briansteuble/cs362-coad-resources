require 'rails_helper'

RSpec.describe 'Deleting a Region', type: :feature do
  scenario 'Admin user deletes a region successfully' do
    admin = User.create!(email: 'admin@example.com', password: 'password', role: :admin)
    admin.confirm

    region = Region.create!(name: 'Region to Delete')

    visit new_user_session_path
    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit region_path(region)

    click_link 'Delete'

    expect(page).to have_current_path(regions_path)
    expect(page).to have_content("was deleted")
    expect(Region.exists?(region.id)).to be false
  end

  scenario 'Non-admin user tries to delete => redirect' do
    user = User.create!(email: 'user@example.com', password: 'password')
    user.confirm
    region = Region.create!(name: 'Region that remains')

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit region_path(region)
    click_link 'Delete' rescue nil
    page.driver.submit :delete, region_path(region), {}

    expect(page).to have_current_path(dashboard_path)
    expect(Region.exists?(region.id)).to be true
  end
end
