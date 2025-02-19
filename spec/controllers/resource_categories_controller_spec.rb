require 'rails_helper'

RSpec.describe ResourceCategoriesController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    ResourceCategory.delete_all 
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
      before do
        sign_in non_admin_user
        get :index
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when user is admin" do
      before do
        sign_in admin
        create(:resource_category, name: "Alpha")
        create(:resource_category, name: "Beta")
        get :index
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns @resource_categories ordered by name" do
        expect(assigns(:resource_categories).map(&:name)).to eq(["Alpha", "Beta"])
      end
    end
  end

  describe "GET #show" do
    let(:category) { create(:resource_category) }

    context "when user is not logged in" do
      it "redirects to login" do
        get :show, params: { id: category.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before do
        sign_in non_admin_user
        get :show, params: { id: category.id }
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when user is admin" do
      before do
        sign_in admin
        get :show, params: { id: category.id }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns @resource_category" do
        expect(assigns(:resource_category)).to eq(category)
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
      before do
        sign_in non_admin_user
        get :new
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when user is admin" do
      before do
        sign_in admin
        get :new
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns a new resource_category" do
        expect(assigns(:resource_category)).to be_a_new(ResourceCategory)
      end
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { { name: "New Category" } }
    let(:invalid_attributes) { { name: "" } }

    context "when user is not logged in" do
      it "redirects to login" do
        post :create, params: { resource_category: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before { sign_in non_admin_user }

      it "redirects to dashboard" do
        post :create, params: { resource_category: valid_attributes }
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when user is admin" do
      before { sign_in admin }

      it "creates a new resource category and redirects to index if valid" do
        expect {
          post :create, params: { resource_category: valid_attributes }
        }.to change(ResourceCategory, :count).by(1)
        expect(response).to redirect_to(resource_categories_path)
        expect(flash[:notice]).to eq("Category successfully created.")
      end

      it "renders :new if invalid" do
        post :create, params: { resource_category: invalid_attributes }
        expect(response).to render_template(:new)
        expect(assigns(:resource_category)).to be_present
      end
    end
  end

  describe "GET #edit" do
    let!(:category) { create(:resource_category) }

    context "when user is not logged in" do
      it "redirects to login" do
        get :edit, params: { id: category.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before do
        sign_in non_admin_user
        get :edit, params: { id: category.id }
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when user is admin" do
      before do
        sign_in admin
        get :edit, params: { id: category.id }
      end

      it "returns a successful response" do
        expect(response).to have_http_status(:success)
      end

      it "assigns the correct resource_category" do
        expect(assigns(:resource_category)).to eq(category)
      end
    end
  end

  describe "PATCH #update" do
    let!(:category) { create(:resource_category, name: "Old Category") }

    context "when user is not logged in" do
      it "redirects to login" do
        patch :update, params: { id: category.id, resource_category: { name: "Updated Category" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before { sign_in non_admin_user }

      it "redirects to dashboard and does not update" do
        patch :update, params: { id: category.id, resource_category: { name: "Updated Category" } }
        expect(response).to redirect_to(dashboard_path)
        expect(category.reload.name).to eq("Old Category")
      end
    end

    context "when user is admin" do
      before { sign_in admin }

      it "updates the category and redirects to show if valid" do
        patch :update, params: { id: category.id, resource_category: { name: "Updated Category" } }
        expect(category.reload.name).to eq("Updated Category")
        expect(response).to redirect_to(resource_category_path(category))
        expect(flash[:notice]).to eq("Category successfully updated.")
      end

      it "renders :edit if invalid" do
        patch :update, params: { id: category.id, resource_category: { name: "" } }
        expect(response).to render_template(:edit)
        expect(category.reload.name).to eq("Old Category")
      end
    end
  end

  describe "POST #activate" do
    let!(:category) { create(:resource_category, active: false) }

    context "when user is not logged in" do
      it "redirects to login" do
        post :activate, params: { id: category.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before { sign_in non_admin_user }

      it "redirects to dashboard without activating" do
        post :activate, params: { id: category.id }
        expect(response).to redirect_to(dashboard_path)
        expect(category.reload.active).to be false
      end
    end

    context "when user is admin" do
      before { sign_in admin }

      it "activates the category and redirects to show with notice" do
        post :activate, params: { id: category.id }
        expect(category.reload.active).to be true
        expect(response).to redirect_to(resource_category_path(category))
        expect(flash[:notice]).to eq("Category activated.")
      end
    end
  end

  describe "POST #deactivate" do
    let!(:category) { create(:resource_category, active: true) }

    context "when user is not logged in" do
      it "redirects to login" do
        post :deactivate, params: { id: category.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before { sign_in non_admin_user }

      it "redirects to dashboard without deactivating" do
        post :deactivate, params: { id: category.id }
        expect(response).to redirect_to(dashboard_path)
        expect(category.reload.active).to be true
      end
    end

    context "when user is admin" do
      before { sign_in admin }

      it "deactivates the category and redirects to show with notice" do
        post :deactivate, params: { id: category.id }
        expect(category.reload.active).to be false
        expect(response).to redirect_to(resource_category_path(category))
        expect(flash[:notice]).to eq("Category deactivated.")
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:category) { create(:resource_category, name: "To Be Deleted") }

    context "when user is not logged in" do
      it "redirects to login" do
        delete :destroy, params: { id: category.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before do
        sign_in non_admin_user
      end

      it "redirects to dashboard and does not destroy category" do
        expect {
          delete :destroy, params: { id: category.id }
        }.not_to change(ResourceCategory, :count)
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when user is admin" do
      before do
        sign_in admin

        # Stub out DeleteResourceCategoryService
        service_double = instance_double(DeleteResourceCategoryService)
        allow(service_double).to receive(:run!) { category.destroy }
        allow(DeleteResourceCategoryService).to receive(:new).with(category).and_return(service_double)
      end

      it "destroys the category and redirects with notice" do
        expect {
          delete :destroy, params: { id: category.id }
        }.to change(ResourceCategory, :count).by(-1)
        expect(response).to redirect_to(resource_categories_path)
        expect(flash[:notice]).to include("Associated tickets now belong to the 'Unspecified' category")
      end
    end
  end
end
