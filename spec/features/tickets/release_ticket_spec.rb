require 'rails_helper'

RSpec.describe 'Releasing a ticket', type: :feature do
  scenario 'The org that holds the ticket releases it back to open' do
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
      name: 'Captured Ticket',
      phone: '+1-555-555-5555',
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
    click_link 'Release'

    ticket.reload
    expect(ticket.organization).to be_nil
  end

  scenario 'A different org sees no Release link' do
    org1 = Organization.create!(
      name: 'Holding Org',
      status: :approved,
      phone: '+1-555-111-1111',
      email: 'holding@example.com',
      primary_name: 'Hold Person',
      secondary_name: 'Hold2',
      secondary_phone: '+1-555-222-2222'
    )
    user1 = User.create!(email: 'org1@example.com', password: 'password', role: :organization, organization: org1)
    user1.confirm

    org2 = Organization.create!(
      name: 'Other Org',
      status: :approved,
      phone: '+1-555-333-3333',
      email: 'other@example.com',
      primary_name: 'Other Person',
      secondary_name: 'Sec Person',
      secondary_phone: '+1-555-444-4444'
    )
    user2 = User.create!(email: 'org2@example.com', password: 'password', role: :organization, organization: org2)
    user2.confirm

    region = Region.create!(name: 'Region1')
    resource = ResourceCategory.create!(name: 'Resource1')
    ticket = Ticket.create!(
      name: 'Captured',
      phone: '+1-555-999-9999',
      region: region,
      resource_category: resource,
      organization: org1
    )

    visit new_user_session_path
    fill_in 'Email', with: 'org2@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit ticket_path(ticket)
    expect(page).not_to have_link('Release')
  end
end
