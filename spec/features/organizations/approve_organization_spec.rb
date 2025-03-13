require 'rails_helper'

RSpec.describe 'Approving an organization', type: :feature do
  scenario 'Admin user approves a submitted organization' do
    admin = User.create!(email: 'admin@example.com', password: 'password', role: :admin)
    admin.confirm

    org = Organization.create!(
      name: 'Submitted Org', 
      email: 'submitted@example.com', 
      phone: '555-1111', 
      status: :submitted,
      primary_name: 'Primary Person',
      secondary_name: 'Backup Person',
      secondary_phone: '555-2222'
    )

    visit new_user_session_path
    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit organization_path(org)

    click_link 'Approve'

    expect(page).to have_content("has been approved")
    org.reload
    expect(org.approved?).to be true
  end
end
