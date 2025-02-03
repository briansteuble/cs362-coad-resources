require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the DashboardHelper. For example:
#
# describe DashboardHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe DashboardHelper, type: :helper do
  let!(:admin) { User.create!(email: "admin@example.com", password: "password", role: :admin) }
  let!(:submitted_org) { Organization.create!(name: "Submitted Org", email: "submitted@example.com", phone: "1234567890", status: :submitted, primary_name: "Name", secondary_name: "safjsaf", secondary_phone: "9876543210") }
  let!(:approved_org) { Organization.create!(name: "Approved Org", email: "approved@example.com", phone: "1234567890", status: :approved, primary_name: "NAmer", secondary_name: "gsafsaa", secondary_phone: "9876543210") }
  let!(:user_with_submitted_org) { User.create!(email: "submitted_user@example.com", password: "password", role: :organization, organization: submitted_org) }
  let!(:user_with_approved_org) { User.create!(email: "approved_user@example.com", password: "password", role: :organization, organization: approved_org) }
  let!(:user_without_org) { User.create!(email: "no_org@example.com", password: "password", role: :organization) }

  it "returns admin_dashboard for a admin user" do
    expect(helper.dashboard_for(admin)).to eq "admin_dashboard"
  end

  it "returns organization_submitted_dashboard for a user with a submitted organization" do
    expect(helper.dashboard_for(user_with_submitted_org)).to eq "organization_submitted_dashboard"
  end

  it "returns organization_approved_dashboard for a user with a approved organization" do
    expect(helper.dashboard_for(user_with_approved_org)).to eq "organization_approved_dashboard"
  end

  it "returns create_application_dashboard for a user without a organization" do
    expect(helper.dashboard_for(user_without_org)).to eq "create_application_dashboard"
  end
end
