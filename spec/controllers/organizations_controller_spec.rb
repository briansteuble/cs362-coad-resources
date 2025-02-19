require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    Ticket.delete_all  
  end

  let(:admin) { create(:user, :admin) }
  let(:approved_org) { create(:organization, status: :approved) }
  let(:submitted_org) { create(:organization, status: :submitted) }
  let(:organization_user) { create(:user, organization: approved_org) }
  let(:unapproved_user) { create(:user, organization: submitted_org) }

  before(:each) do
    admin.confirm unless admin.confirmed?
    organization_user.confirm unless organization_user.confirmed?
    unapproved_user.confirm unless unapproved_user.confirmed?
  end

  describe "GET #index" do
    context "when user is an admin" do
      before(:each) do
        sign_in admin
        get :index
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns @status_options for admin" do
        expect(assigns(:status_options)).to eq(['Open', 'Captured', 'Closed'])
      end
    end

    context "when user is an approved organization member" do
      before(:each) do
        sign_in organization_user
        get :index
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns @status_options for approved organization" do
        expect(assigns(:status_options)).to eq(['Open', 'My Captured', 'My Closed'])
      end
    end

    context "when user is an organization member but not approved" do
      before(:each) do
        sign_in unapproved_user
        get :index
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns @status_options for unapproved organization" do
        expect(assigns(:status_options)).to eq(['Open'])
      end
    end

    context "when user is not logged in" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when filtering tickets by status" do
      let!(:open_ticket) { create(:ticket) }
      
      let!(:closed_ticket) do
        region = create(:region)
        resource_category = create(:resource_category)
        ticket = create(:ticket, :closed, region: region, resource_category: resource_category)
        unique_name = "Closed Ticket Unique #{Time.now.to_i}-#{rand(100000)}"
        ticket.update!(name: unique_name)
        ticket
      end

      it "assigns open tickets when status is 'Open'" do
        sign_in admin
        get :index, params: { status: 'Open' }
        expect(assigns(:tickets)).to include(open_ticket)
        expect(assigns(:tickets)).not_to include(closed_ticket)
      end

      it "assigns closed tickets when status is 'Closed'" do
        sign_in admin
        get :index, params: { status: 'Closed' }
        expect(assigns(:tickets)).to include(closed_ticket)
        expect(assigns(:tickets)).not_to include(open_ticket)
      end
    end
  end
end
