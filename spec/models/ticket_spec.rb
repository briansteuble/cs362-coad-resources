require 'rails_helper'

RSpec.describe Ticket, type: :model do

  let (:ticket) {build(:ticket)}

describe "attributes tests" do

  it "exists" do
    expect(ticket).to be_a(Ticket)
  end

  it "responds to name" do
    expect(ticket).to respond_to(:name)
  end

  it "responds to description" do
    expect(ticket).to respond_to(:description)
  end

  it "responds to phone" do
    expect(ticket).to respond_to(:phone)
  end

  it "belongs to region" do
    should belong_to(:region)
  end

  it "belongs to resource category" do
    should belong_to(:resource_category)
  end

  it "can belong to organization" do
    should belong_to(:organization).optional
  end

end

describe "validation tests" do

#validates_presence_of :name, :phone, :region_id, :resource_category_id
#validates_length_of :name, minimum: 1, maximum: 255, on: :create
#validates_length_of :description, maximum: 1020, on: :create
#validates :phone, phony_plausible: true

  it "validates presence of name" do
    expect(ticket).to validate_presence_of(:name)
  end

  it "validates presence of phone" do
    expect(ticket).to validate_presence_of(:phone)
  end

  it "validates presence of region id" do
    expect(ticket).to validate_presence_of(:region_id)
  end

  it "validates presence of resource category id" do
    expect(ticket).to validate_presence_of(:resource_category_id)
  end

  it "validates name length" do
    expect(ticket).to validate_length_of(:name).is_at_least(1)
    expect(ticket).to validate_length_of(:name).is_at_most(255)
  end

  it "validates description length" do
    expect(ticket).to validate_length_of(:description).is_at_most(1020)
  end

  it "validates plausible phone" do
    should allow_value('+1-555-555-5555').for(:phone)
  end

end

describe "member function tests" do

  it "converts to string" do
    expect(ticket.to_s).to eq "Ticket #{ticket.id}"
  end

  it "a new ticket is set to open by default" do
    expect(ticket.open?).to eq true
  end

  it "a closed ticket is not open" do
    ticket.closed = true
    expect(ticket.open?).to eq false
  end

  it "is a new ticket uncaptured by default?" do
    expect(ticket.captured?).to eq false
  end

end

describe "scope tests" do

  let!(:region) { create(:region, name: "Region 1") }
  let!(:resource_category) { create(:resource_category, name: "Resource 1") }
  let!(:organization) { create(:organization, name: "Org 1") }
  
  let!(:open_ticket) { create(:ticket, closed: false, organization: nil, region: region, resource_category: resource_category) }
  let!(:closed_ticket) { create(:ticket, closed: true, region: region, resource_category: resource_category) }
  let!(:assigned_ticket) { create(:ticket, closed: false, organization: organization, region: region, resource_category: resource_category) }
  let!(:closed_org_ticket) { create(:ticket, closed: true, organization: organization, region: region, resource_category: resource_category) }
  let!(:region_ticket) { create(:ticket, closed: false, region: region, resource_category: resource_category) }
  let!(:resource_ticket) { create(:ticket, closed: false, region: region, resource_category: resource_category) }

 # scope :open, -> () { where closed: false, organization_id: nil }
 # scope :closed, -> () { where closed: true }
 # scope :all_organization, -> () { where(closed: false).where.not(organization_id: nil) }
 # scope :organization, -> (organization_id) { where(organization_id: organization_id, closed: false) }
 # scope :closed_organization, -> (organization_id) { where(organization_id: organization_id, closed: true) }
 # scope :region, -> (region_id) { where(region_id: region_id) }
 # scope :resource_category, -> (resource_category_id) { where(resource_category_id: resource_category_id) }

  it "returns only open tickets (closed: false, organization_id: nil)" do
    expect(Ticket.open).to include(open_ticket)
    expect(Ticket.open).not_to include(closed_ticket, assigned_ticket)
  end

  it "returns only closed tickets (closed: true)" do
    expect(Ticket.closed).to include(closed_ticket, closed_org_ticket)
    expect(Ticket.closed).not_to include(open_ticket, assigned_ticket)
  end

  it "returns all assigned organization tickets (closed: false, organization_id NOT nil)" do
    expect(Ticket.all_organization).to include(assigned_ticket)
    expect(Ticket.all_organization).not_to include(open_ticket, closed_ticket)
  end

  it "returns only tickets assigned to a specific organization (closed: false)" do
    expect(Ticket.organization(organization.id)).to include(assigned_ticket)
    expect(Ticket.organization(organization.id)).not_to include(open_ticket, closed_ticket, closed_org_ticket)
  end

  it "returns only closed tickets for a specific organization" do
    expect(Ticket.closed_organization(organization.id)).to include(closed_org_ticket)
    expect(Ticket.closed_organization(organization.id)).not_to include(open_ticket, assigned_ticket, closed_ticket)
  end

  it "returns only tickets assigned to a specific region" do
    expect(Ticket.region(region.id)).to match_array([open_ticket, assigned_ticket, closed_ticket, closed_org_ticket, region_ticket, resource_ticket])
  end

  it "returns only tickets assigned to a specific resource category" do
    expect(Ticket.resource_category(resource_category.id)).to match_array([open_ticket, assigned_ticket, closed_ticket, closed_org_ticket, region_ticket, resource_ticket])  
  end
    
  end

end
