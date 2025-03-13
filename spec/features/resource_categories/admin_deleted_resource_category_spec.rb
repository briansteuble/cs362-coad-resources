require 'rails_helper'

RSpec.describe 'Deleting a Resource Category', type: :feature do
  scenario 'Admin user deletes a resource category successfully' do
    admin = User.create!(email: 'admin@example.com', password: 'password', role: :admin)
    admin.confirm

    category = ResourceCategory.create!(name: 'Category to Delete')

    visit new_user_session_path
    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit resource_category_path(category)

    click_link 'Delete'

    expect(page).to have_current_path(resource_categories_path)
    expect(page).to have_content("Associated tickets now belong to the 'Unspecified' category")

    expect(ResourceCategory.exists?(category.id)).to be false
  end

  scenario 'Non-admin user tries to delete => redirect to dashboard' do
    user = User.create!(email: 'user@example.com', password: 'password')
    user.confirm

    category = ResourceCategory.create!(name: 'Category that remains')

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit resource_category_path(category)
    click_link 'Delete' rescue nil

    expect(page).to have_current_path(dashboard_path)
    expect(ResourceCategory.exists?(category.id)).to be true
  end
end
