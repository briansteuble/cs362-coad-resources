require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET #index" do
    context "when user is not logged in" do
      it "redirects to sign in" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is logged in but not admin" do
      before do
        user = User.create!(email: 'user@example.com', password: 'password', role: :organization)
        user.confirm
        sign_in user
        get :index
      end

      it "redirects to dashboard" do
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when user is admin" do
      before do
        admin = User.create!(email: 'admin@example.com', password: 'password', role: :admin)
        admin.confirm
        sign_in admin
        get :index
      end

      it "returns success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns @users" do
        expect(assigns(:users)).to eq(User.all)
      end
    end
  end
end
