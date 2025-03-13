require 'rails_helper'

RSpec.describe 'Creating an Organization Application', type: :feature do
  scenario 'User with no organization applies successfully' do
    user = User.create!(email: 'testuser@example.com', password: 'password')
    user.confirm

    allow(UserMailer).to receive_message_chain(:with, :new_organization_application, :deliver_now)

    visit new_user_session_path
    fill_in 'Email', with: 'testuser@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit new_organization_path

    choose 'organization_liability_insurance_true'
    choose 'organization_agreement_one_true'
    choose 'organization_agreement_two_true'
    choose 'organization_agreement_three_true'
    choose 'organization_agreement_four_true'
    choose 'organization_agreement_five_true'
    choose 'organization_agreement_six_true'
    choose 'organization_agreement_seven_true'
    choose 'organization_agreement_eight_true'

    fill_in 'What is your name? (Last, First)', with: 'Doe, Jane'
    fill_in 'Organization Name', with: 'My Great Org'
    fill_in 'What is your title? (if applicable)', with: 'CEO'
    fill_in 'What is your direct phone number? Cell phone is best.', with: '555-1234'
    fill_in 'Who may we contact regarding your organization\'s application if we are unable to reach you?', with: 'Backup Person'
    fill_in 'What is a good secondary phone number we may reach your organization at?', with: '555-5678'
    fill_in 'What is your Organization\'s email?', with: 'myorg@example.com'
    fill_in 'Description', with: 'We provide donated goods.'
    choose 'organization_transportation_yes'

    click_button 'Apply'

    expect(page).to have_current_path(organization_application_submitted_path)
    new_org = Organization.find_by(email: 'myorg@example.com')
    expect(new_org).not_to be_nil
    expect(user.reload.organization).to eq(new_org)
  end

  scenario 'User leaves required fields blank => sees error' do
    user = User.create!(email: 'baduser@example.com', password: 'password')
    user.confirm

    allow(UserMailer).to receive_message_chain(:with, :new_organization_application, :deliver_now)

    visit new_user_session_path
    fill_in 'Email', with: 'baduser@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign in'

    visit new_organization_path

    choose 'organization_liability_insurance_true'
    choose 'organization_agreement_one_true'


    click_button 'Apply'
    expect(page).to have_content("can't be blank")
  end
end
