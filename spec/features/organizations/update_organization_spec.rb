require 'rails_helper'

RSpec.describe 'Updating an Organization', type: :feature do
  scenario 'Approved org user updates their org details' do
    org = Organization.create!(
      name: 'Old Org',
      email: 'oldorg@example.com',
      phone: '555-1111',
      status: :approved,
      primary_name: 'Old Primary',
      secondary_name: 'Old Secondary',
      secondary_phone: '555-2222'
    )
    user = User.create!(
      email: 'user@example.com',
      password: 'password',
      role: :organization,
      organization: org
    )
    user.confirm

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit edit_organization_path(org)

    fill_in 'Name', with: 'New Org Name'
    fill_in 'Phone', with: '555-9999'
    fill_in 'Email', with: 'neworg@example.com'
    fill_in 'Description', with: 'Updated description'

    click_button 'Update Resource'

    org.reload
    expect(org.name).to eq('New Org Name')
    expect(org.email).to eq('neworg@example.com')
    expect(org.description).to eq('Updated description')
  end
end
