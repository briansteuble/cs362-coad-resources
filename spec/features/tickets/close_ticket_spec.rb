require 'rails_helper'

RSpec.describe 'Closing a ticket', type: :feature do
  scenario 'An org holding the ticket closes it' do
    org = Organization.create!(
      name: 'Approved Org',
      status: :approved,
      phone: '+1-555-111-1111',
      email: 'org@example.com',
      primary_name: 'Prim Name',
      secondary_name: 'Sec Name',
      secondary_phone: '+1-555-222-2222'
    )
    user = User.create!(email: 'user@example.com', password: 'password', role: :organization, organization: org)
    user.confirm

    region = Region.create!(name: 'Region1')
    resource = ResourceCategory.create!(name: 'Resource1')
    ticket = Ticket.create!(
      name: 'Ticket to Close',
      phone: '+1-555-999-9999',
      region: region,
      resource_category: resource,
      organization: org,
      closed: false
    )

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit ticket_path(ticket)
    click_link 'Close'
    ticket.reload
    expect(ticket.closed?).to be true
  end

  scenario 'Admin closes an open ticket that has no org' do
    admin = User.create!(email: 'admin@example.com', password: 'password', role: :admin)
    admin.confirm

    region = Region.create!(name: 'Region2')
    resource = ResourceCategory.create!(name: 'Resource2')
    ticket = Ticket.create!(
      name: 'Admin closes me',
      phone: '+1-555-444-9999',
      region: region,
      resource_category: resource,
      closed: false
    )

    visit new_user_session_path
    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit ticket_path(ticket)
    click_link 'Close'
    ticket.reload
    expect(ticket.closed?).to be true
  end
end
