require 'rails_helper'

RSpec.describe 'Rejecting an organization', type: :feature do
  scenario 'Admin rejects a submitted organization with a reason' do
    admin = User.create!(email: 'admin@example.com', password: 'password', role: :admin)
    admin.confirm

    org = Organization.create!(
      name: 'Org To Reject',
      email: 'reject@example.com',
      phone: '555-4444',
      status: :submitted,
      primary_name: 'Prim Name',
      secondary_name: 'Sec Name',
      secondary_phone: '555-5555'
    )

    visit new_user_session_path
    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit organization_path(org)

    fill_in 'Rejection Reason', with: 'Incomplete docs'
    click_button 'Reject'

    expect(page).to have_content("has been rejected")
    org.reload
    expect(org.rejected?).to be true
    expect(org.rejection_reason).to eq('Incomplete docs')
  end
end
