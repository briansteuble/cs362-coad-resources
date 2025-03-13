require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    Organization.delete_all  
  end

  let(:admin) { create(:user, :admin) }
  let(:approved_org) { create(:organization, status: :approved) }
  let(:submitted_org) { create(:organization, status: :submitted) }

  let(:approved_user) { create(:user, organization: approved_org) }

  let(:unapproved_user) { create(:user, organization: submitted_org) }

  let(:no_org_user) { create(:user) }

  before(:each) do
    admin.confirm unless admin.confirmed?
    approved_user.confirm unless approved_user.confirmed?
    unapproved_user.confirm unless unapproved_user.confirmed?
    no_org_user.confirm unless no_org_user.confirmed?
  end

  describe "GET #index" do
    context "when user is not logged in" do
      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in" do
      before(:each) do
        sign_in approved_user
        create(:organization, name: "Org A", email: "orga@example.com")
        create(:organization, name: "Org B", email: "orgb@example.com")
        get :index
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns @organizations ordered by name" do
        expect(assigns(:organizations)).to eq(Organization.all.order(:name))
      end
    end
  end

  describe "GET #new" do
    context "when current_user has no organization" do
      before(:each) do
        sign_in no_org_user
        get :new
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns a new Organization" do
        expect(assigns(:organization)).to be_a_new(Organization)
      end
    end

    context "when current_user already has an organization" do
      before(:each) do
        sign_in approved_user
        get :new
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "POST #create" do
    let(:valid_attributes) do
      {
        name: "New Org",
        phone: "555-1234",
        email: "neworg@example.com",
        primary_name: "Primary Name",
        secondary_name: "Secondary Name",
        secondary_phone: "555-5678"
      }
    end

    context "when user has no organization" do
      before(:each) do
        sign_in no_org_user
        allow(UserMailer).to receive_message_chain(:with, :new_organization_application, :deliver_now)
      end

      it "creates a new organization and redirects to application_submitted if valid" do
        expect {
          post :create, params: { organization: valid_attributes }
        }.to change(Organization, :count).by(1)
        expect(response).to redirect_to(organization_application_submitted_path)
        expect(no_org_user.reload.organization).not_to be_nil
      end

      it "renders :new if invalid" do
        post :create, params: { organization: valid_attributes.merge(name: "") }
        expect(response).to render_template(:new)
      end
    end

    context "when user already has an organization" do
      before(:each) { sign_in approved_user }

      it "redirects to dashboard" do
        post :create, params: { organization: valid_attributes }
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "GET #edit" do
    context "when user is approved" do
      before(:each) do
        sign_in approved_user
        get :edit, params: { id: approved_user.organization.id }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not approved" do
      before(:each) do
        sign_in unapproved_user
        get :edit, params: { id: unapproved_user.organization.id }
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "PATCH #update" do
    let!(:org_record) { create(:organization, name: "Old Org", status: :approved) }

    context "when user is approved" do
      before(:each) do
        sign_in approved_user
        approved_user.update!(organization: org_record)
      end

      it "updates the organization and redirects to show" do
        patch :update, params: {
          id: org_record.id,
          organization: { name: "Updated Org" }
        }
        expect(org_record.reload.name).to eq("Updated Org")
        expect(response).to redirect_to(organization_path(id: org_record.id))
      end

      it "renders :edit if invalid" do
        patch :update, params: {
          id: org_record.id,
          organization: { name: "" }
        }
        expect(response).to render_template(:edit)
      end
    end

    context "when user is not approved" do
      before(:each) do
        sign_in unapproved_user
        patch :update, params: {
          id: submitted_org.id,
          organization: { name: "Won't matter" }
        }
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "GET #show" do
    let!(:org_record) { create(:organization, status: :approved) }

    context "when user is admin" do
      before(:each) do
        sign_in admin
        get :show, params: { id: org_record.id }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is approved organization member" do
      before(:each) do
        org_record.update!(status: :approved)
        approved_user.update!(organization: org_record)
        sign_in approved_user
        get :show, params: { id: org_record.id }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not approved or admin" do
      before(:each) do
        sign_in unapproved_user
        get :show, params: { id: org_record.id }
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "POST #approve" do
    let!(:org_record) { create(:organization, status: :submitted) }

    context "when user is admin" do
      before(:each) do
        sign_in admin
        post :approve, params: { id: org_record.id }
      end

      it "approves the organization and redirects to organizations_path" do
        expect(org_record.reload.approved?).to be true
        expect(response).to redirect_to(organizations_path)
      end
    end

    context "when user is not admin" do
      before(:each) do
        sign_in approved_user
        post :approve, params: { id: org_record.id }
      end

      it "redirects to dashboard" do
        expect(org_record.reload.submitted?).to be true
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end

  describe "POST #reject" do
    let!(:org_record) { create(:organization, status: :submitted) }

    context "when user is admin" do
      let(:reason) { "Missing info" }

      before(:each) do
        sign_in admin
        post :reject, params: { id: org_record.id, organization: { rejection_reason: reason } }
      end

      it "rejects the organization and redirects to organizations_path" do
        org_record.reload
        expect(org_record.rejected?).to be true
        expect(org_record.rejection_reason).to eq(reason)
        expect(response).to redirect_to(organizations_path)
      end
    end

    context "when user is not admin" do
      before(:each) do
        sign_in approved_user
        post :reject, params: { id: org_record.id, organization: { rejection_reason: "Another reason" } }
      end

      it "redirects to dashboard without rejecting" do
        expect(org_record.reload.submitted?).to be true
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
