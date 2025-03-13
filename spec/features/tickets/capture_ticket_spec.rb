require 'rails_helper'

RSpec.describe 'Capturing a ticket', type: :feature do
  scenario 'An approved organization user captures an open ticket' do
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
    resource = ResourceCategory.create!(name: 'Resource1', active: true)
    ticket = Ticket.create!(
      name: 'Test Ticket',
      phone: '+1-555-555-5555',
      region: region,
      resource_category: resource,
      closed: false
    )

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit ticket_path(ticket)
    click_link 'Capture'

    ticket.reload
    expect(ticket.organization).to eq(org)
  end

  scenario 'A non-approved org user does not see a Capture link' do
    unapproved_org = Organization.create!(
      name: 'Unapproved Org',
      status: :submitted,
      phone: '+1-555-777-7777',
      email: 'unapproved@example.com',
      primary_name: 'Prim Person',
      secondary_name: 'Sec Person',
      secondary_phone: '+1-555-888-8888'
    )
    user = User.create!(
      email: 'unapproved_user@example.com',
      password: 'password',
      role: :organization,
      organization: unapproved_org
    )
    user.confirm

    region = Region.create!(name: 'Region1')
    resource = ResourceCategory.create!(name: 'Resource1', active: true)
    ticket = Ticket.create!(name: 'Uncaptured Ticket', phone: '+1-555-111-2222', region: region, resource_category: resource)

    visit new_user_session_path
    fill_in 'Email', with: 'unapproved_user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit ticket_path(ticket)
    expect(page).not_to have_link('Capture')
  end
end
