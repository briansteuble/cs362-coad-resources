require 'rails_helper'

RSpec.describe 'Deleting a Ticket', type: :feature do
  scenario 'Admin user deletes a ticket successfully' do
    admin = User.create!(email: 'admin@example.com', password: 'password', role: :admin)
    admin.confirm

    region = Region.create!(name: 'Region1')
    resource = ResourceCategory.create!(name: 'Resource1')
    ticket = Ticket.create!(
      name: 'Ticket to Delete',
      phone: '+1-555-444-4444',
      region: region,
      resource_category: resource
    )

    visit new_user_session_path
    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit ticket_path(ticket)
    click_link 'Delete'
    expect(page).to have_content('was deleted')
    expect(Ticket.exists?(ticket.id)).to be false
  end

  scenario 'Non-admin user sees no Delete link' do
    user = User.create!(email: 'user@example.com', password: 'password', role: :organization)
    user.confirm

    region = Region.create!(name: 'Region2')
    resource = ResourceCategory.create!(name: 'Resource2')
    ticket = Ticket.create!(
      name: 'Undeletable Ticket',
      phone: '+1-555-555-5555',
      region: region,
      resource_category: resource
    )

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit ticket_path(ticket)
    expect(page).not_to have_link('Delete')
  end
end
