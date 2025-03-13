require 'rails_helper'

RSpec.describe 'Creating a Ticket', type: :feature do
  scenario 'A visitor (non-logged-in) fills out the Get Help form successfully' do
    region = Region.create!(name: 'Portland')
    resource = ResourceCategory.create!(name: 'Food', active: true)

    visit new_ticket_path
    fill_in 'Full Name', with: 'Jane Doe'
    fill_in 'Phone Number', with: '+1-555-123-4567'  
    select 'Portland', from: 'Region'
    select 'Food', from: 'Resource Category'
    fill_in 'Description', with: 'I need help with groceries.'
    click_button 'Send this help request'

    new_ticket = Ticket.last
    expect(new_ticket).not_to be_nil
    expect(new_ticket.name).to eq('Jane Doe')
    expect(new_ticket.phone).to eq('+15551234567')
    expect(new_ticket.region).to eq(region)
    expect(new_ticket.resource_category).to eq(resource)
    expect(new_ticket.description).to eq('I need help with groceries.')
  end

  scenario 'A visitor leaves required fields blank => sees error' do
    visit new_ticket_path
    click_button 'Send this help request'
    expect(page).to have_content("can't be blank")
  end
end
