require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    Ticket.delete_all
  end

  let!(:ticket) { create(:ticket) }  

  let!(:region) { create(:region) }
  let!(:resource_category) { create(:resource_category) }

  let(:valid_params) do
    {
      name: "Valid Ticket",
      phone: "+1-555-555-1212",  
      region_id: region.id,
      resource_category_id: resource_category.id,
      description: "Some description"
    }
  end

  let(:admin_org) { create(:organization, status: :approved) }
  let(:admin) { create(:user, :admin, organization: admin_org) }

  let(:approved_org) { create(:organization, status: :approved) }
  let(:unapproved_org) { create(:organization, status: :submitted) }

  let(:approved_user) { create(:user, organization: approved_org) }
  let(:unapproved_user) { create(:user, organization: unapproved_org) }
  let(:no_org_user) { create(:user) }

 
  before do
    [admin, approved_user, unapproved_user, no_org_user].each do |u|
      u.confirm unless u.confirmed?
    end
  end

  describe "GET #new" do
    context "non-logged-in" do
      it "renders new (no user check in code) => 200 OK" do
        get :new
        expect(response).to have_http_status(:ok)
      end
    end

    context "approved_user" do
      before do
        sign_in approved_user
        get :new
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns(:ticket)).to be_a_new(Ticket) }
    end
  end

  describe "POST #create" do
    context "non-logged-in" do
      it "allows creation (no user checks) => increments Ticket.count" do
        expect {
          post :create, params: { ticket: valid_params }
        }.to change(Ticket, :count).by(1)
        expect(response).to redirect_to(ticket_submitted_path)
      end
    end

    context "approved_user" do
      before { sign_in approved_user }

      it "creates ticket => ticket_submitted if valid" do
        expect {
          post :create, params: { ticket: valid_params }
        }.to change(Ticket, :count).by(1)
        expect(response).to redirect_to(ticket_submitted_path)
      end

      it "renders :new if invalid" do
        post :create, params: { ticket: valid_params.merge(name: "") }
        expect(response).to render_template(:new)
        expect(Ticket.count).to eq(1) 
      end
    end
  end

  describe "GET #show" do
    context "non-logged-in" do
      it "raises NoMethodError because code calls current_user.admin? w/o safe nav" do
        expect {
          get :show, params: { id: ticket.id }
        }.to raise_error(NoMethodError, /admin\?/)
      end
    end

    context "unapproved user" do
      before { sign_in unapproved_user }

      it "redirects to dashboard" do
        get :show, params: { id: ticket.id }
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "approved user" do
      before do
        sign_in approved_user
        get :show, params: { id: ticket.id }
      end
      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns(:ticket)).to eq(ticket) }
    end

    context "admin" do
      before do
        sign_in admin
        get :show, params: { id: ticket.id }
      end
      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe "POST #release" do
    before { allow(TicketService).to receive(:release_ticket).and_return(:ok) }

    context "non-logged-in" do
      it "redirects to dashboard" do
        post :release, params: { id: ticket.id }
        expect(response).to redirect_to(dashboard_path)
        expect(TicketService).not_to have_received(:release_ticket)
      end
    end

    context "unapproved user" do
      before { sign_in unapproved_user }

      it "redirects to dashboard" do
        post :release, params: { id: ticket.id }
        expect(response).to redirect_to(dashboard_path)
        expect(TicketService).not_to have_received(:release_ticket)
      end
    end

    context "approved user" do
      before { sign_in approved_user }

      it "calls release_ticket => #tickets:organization" do
        post :release, params: { id: ticket.id }
        expect(TicketService).to have_received(:release_ticket).with(ticket.id.to_s, approved_user)
        expect(response).to redirect_to(dashboard_path << '#tickets:organization')
      end
    end

    context "admin" do
      before { sign_in admin }

      it "calls release_ticket => #tickets:captured" do
        post :release, params: { id: ticket.id }
        expect(TicketService).to have_received(:release_ticket).with(ticket.id.to_s, admin)
        expect(response).to redirect_to(dashboard_path << '#tickets:captured')
      end
    end
  end

  describe "DELETE #destroy" do
    context "non-logged-in" do
      it "redirects to dashboard if your authenticate_admin does so" do
        delete :destroy, params: { id: ticket.id }
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "approved user" do
      before { sign_in approved_user }

      it "redirects to dashboard" do
        delete :destroy, params: { id: ticket.id }
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "admin" do
      before { sign_in admin }

      it "destroys the ticket => #tickets anchor" do
        expect {
          delete :destroy, params: { id: ticket.id }
        }.to change(Ticket, :count).by(-1)
        expect(response).to redirect_to(dashboard_path << '#tickets')
        expect(flash[:notice]).to include("Ticket #{ticket.id} was deleted.")
      end
    end
  end
end
