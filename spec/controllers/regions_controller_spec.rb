require 'rails_helper'

RSpec.describe RegionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    Region.delete_all  
  end

  let(:admin) { create(:user, :admin) }
  let(:non_admin_user) { create(:user) }

  before(:each) do
    admin.confirm unless admin.confirmed?
    non_admin_user.confirm unless non_admin_user.confirmed?
  end

  describe "GET #index" do
    context "when user is not logged in" do
      it "redirects to login" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before(:each) do
        sign_in non_admin_user
        get :index
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when user is admin" do
      before(:each) do
        sign_in admin
        create(:region, name: "Alpha")
        create(:region, name: "Beta")
        get :index
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns @regions" do
        expect(assigns(:regions).map(&:name)).to match_array(["Alpha", "Beta"])
      end
    end
  end

  describe "GET #show" do
    let(:region) { create(:region) }

    context "when user is not logged in" do
      it "redirects to login" do
        get :show, params: { id: region.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before(:each) do
        sign_in non_admin_user
        get :show, params: { id: region.id }
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when user is admin" do
      before(:each) do
        sign_in admin
        get :show, params: { id: region.id }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns @region (including :tickets)" do
        expect(assigns(:region)).to eq(region)
      end
    end
  end

  describe "GET #new" do
    context "when user is not logged in" do
      it "redirects to login" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before(:each) do
        sign_in non_admin_user
        get :new
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when user is admin" do
      before(:each) do
        sign_in admin
        get :new
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns a new region" do
        expect(assigns(:region)).to be_a_new(Region)
      end
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { { name: "New Region" } }
    let(:invalid_attributes) { { name: "" } }

    context "when user is not logged in" do
      it "redirects to login" do
        post :create, params: { region: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before { sign_in non_admin_user }

      it "redirects to dashboard" do
        post :create, params: { region: valid_attributes }
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when user is admin" do
      before { sign_in admin }

      it "creates a new region with valid attributes" do
        expect {
          post :create, params: { region: valid_attributes }
        }.to change(Region, :count).by(1)
        expect(response).to redirect_to(regions_path)
        expect(flash[:notice]).to eq("Region successfully created.")
      end

      it "renders :new if invalid" do
        post :create, params: { region: invalid_attributes }
        expect(response).to render_template(:new)
        expect(assigns(:region)).to be_present
      end
    end
  end

  describe "GET #edit" do
    let!(:region) { create(:region) }

    context "when user is not logged in" do
      it "redirects to login" do
        get :edit, params: { id: region.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before do
        sign_in non_admin_user
        get :edit, params: { id: region.id }
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when user is admin" do
      before do
        sign_in admin
        get :edit, params: { id: region.id }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns the correct region" do
        expect(assigns(:region)).to eq(region)
      end
    end
  end

  describe "PATCH #update" do
    let!(:region) { create(:region, name: "Old Region") }

    context "when user is not logged in" do
      it "redirects to login" do
        patch :update, params: { id: region.id, region: { name: "Updated Region" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before { sign_in non_admin_user }

      it "redirects to dashboard" do
        patch :update, params: { id: region.id, region: { name: "Updated Region" } }
        expect(response).to redirect_to(dashboard_path)
        expect(region.reload.name).to eq("Old Region")
      end
    end

    context "when user is admin" do
      before { sign_in admin }

      it "updates the region and redirects with valid attributes" do
        patch :update, params: { id: region.id, region: { name: "Updated Region" } }
        expect(region.reload.name).to eq("Updated Region")
        expect(response).to redirect_to(region_path(region))
        expect(flash[:notice]).to eq("Region successfully updated.")
      end

      it "renders :edit if invalid" do
        patch :update, params: { id: region.id, region: { name: "" } }
        expect(response).to render_template(:edit)
        expect(region.reload.name).to eq("Old Region")
      end
    end
  end

  describe "DELETE #destroy" do
  let!(:region) { create(:region, name: "To Be Deleted") }

  context "when user is not logged in" do
    it "redirects to login" do
      delete :destroy, params: { id: region.id }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when user is logged in but not admin" do
    before { sign_in non_admin_user }

    it "redirects to dashboard and does not destroy region" do
      expect {
        delete :destroy, params: { id: region.id }
      }.not_to change(Region, :count)
      expect(response).to redirect_to(dashboard_path)
    end
  end

  context "when user is admin" do
    before do
      sign_in admin
      service_double = instance_double(DeleteRegionService)

      allow(service_double).to receive(:run!) { region.destroy }

      allow(DeleteRegionService).to receive(:new).with(region).and_return(service_double)
    end

    it "destroys the region and redirects to index with notice" do
      expect {
        delete :destroy, params: { id: region.id }
      }.to change(Region, :count).by(-1)
      expect(response).to redirect_to(regions_path)
      expect(flash[:notice]).to include("Associated tickets now belong to the 'Unspecified' region")
    end
  end
end
end
