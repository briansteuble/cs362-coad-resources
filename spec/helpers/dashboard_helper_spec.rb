require 'rails_helper'

RSpec.describe DashboardHelper, type: :helper do
  let!(:admin) do
    User.create!(
      email: "admin@example.com",
      password: "password",
      role: :admin
    )
  end
  let!(:submitted_org) do
    Organization.create!(
      name: "Submitted Org",
      email: "submitted@example.com",
      phone: "1234567890",
      status: :submitted,
      primary_name: "Name",
      secondary_name: "safjsaf",
      secondary_phone: "9876543210"
    )
  end
  let!(:approved_org) do
    Organization.create!(
      name: "Approved Org",
      email: "approved@example.com",
      phone: "1234567890",
      status: :approved,
      primary_name: "NAmer",
      secondary_name: "gsafsaa",
      secondary_phone: "9876543210"
    )
  end
  let!(:user_with_submitted_org) do
    User.create!(
      email: "submitted_user@example.com",
      password: "password",
      role: :organization,
      organization: submitted_org
    )
  end
  let!(:user_with_approved_org) do
    User.create!(
      email: "approved_user@example.com",
      password: "password",
      role: :organization,
      organization: approved_org
    )
  end
  let!(:user_without_org) do
    User.create!(
      email: "no_org@example.com",
      password: "password",
      role: :organization
    )
  end

  it "returns admin_dashboard for an admin user" do
    expect(helper.dashboard_for(admin)).to eq "admin_dashboard"
  end

  it "returns organization_submitted_dashboard for a user with a submitted organization" do
    expect(helper.dashboard_for(user_with_submitted_org)).to eq "organization_submitted_dashboard"
  end

  it "returns organization_approved_dashboard for a user with an approved organization" do
    expect(helper.dashboard_for(user_with_approved_org)).to eq "organization_approved_dashboard"
  end

  it "returns create_application_dashboard for a user without an organization" do
    expect(helper.dashboard_for(user_without_org)).to eq "create_application_dashboard"
  end

  it "stubs a user as admin to demonstrate faking user checks" do
    fake_user = double("User", admin?: true, organization: nil)
    expect(helper.dashboard_for(fake_user)).to eq "admin_dashboard"
  end
end
