require 'rails_helper'

RSpec.describe Ticket, type: :model do

  let (:ticket) {Ticket.new(id: 123)}

describe "attributes tests" do

  it "exists" do
    Ticket.new
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
    expect(ticket.to_s).to eq "Ticket 123"
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

  let!(:region1) { Region.create!(name: "Region 1") }
  let!(:resource1) { ResourceCategory.create!(name: "Resource 1") }
  let!(:organization1) { Organization.create!(name: "Org 1", email: "org1@example.com", phone: "+1-555-555-5555", primary_name: "John", secondary_name: "Smith", secondary_phone: "+1-555-555-5555") }
  
  let!(:open_ticket) { 
    Ticket.create!(
      name: "Open Ticket", 
      closed: false, 
      organization_id: nil, 
      region_id: region1.id, 
      resource_category_id: resource1.id, 
      phone: "+1-555-555-5555"
    ) 
  }
  
  let!(:closed_ticket) { 
    Ticket.create!(
      name: "Closed Ticket", 
      closed: true, 
      region_id: region1.id, 
      resource_category_id: resource1.id, 
      phone: "+1-555-555-5555"
    ) 
  }
  
  let!(:assigned_ticket) { 
    Ticket.create!(
      name: "Assigned Ticket", 
      closed: false, 
      organization_id: organization1.id, 
      region_id: region1.id, 
      resource_category_id: resource1.id, 
      phone: "+1-555-555-5555"
    ) 
  }
  
  let!(:closed_org_ticket) { 
    Ticket.create!(
      name: "Closed Org Ticket", 
      closed: true, 
      organization_id: organization1.id, 
      region_id: region1.id, 
      resource_category_id: resource1.id, 
      phone: "+1-555-555-5555"
    ) 
  }

  let!(:region_ticket) { 
    Ticket.create!(
      name: "Region Ticket",
      closed: false,
      region_id: region1.id, 
      resource_category_id: resource1.id,
      phone: "+1-555-555-5555"
    ) 
  }
  
  let!(:resource_ticket) { 
    Ticket.create!(
      name: "Resource Ticket",
      closed: false,
      region_id: region1.id,
      resource_category_id: resource1.id, 
      phone: "+1-555-555-5555"
    ) 
  }
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
    expect(Ticket.organization(organization1.id)).to include(assigned_ticket)
    expect(Ticket.organization(organization1.id)).not_to include(open_ticket, closed_ticket, closed_org_ticket)
  end

  it "returns only closed tickets for a specific organization" do
    expect(Ticket.closed_organization(organization1.id)).to include(closed_org_ticket)
    expect(Ticket.closed_organization(organization1.id)).not_to include(open_ticket, assigned_ticket, closed_ticket)
  end

  it "returns only tickets assigned to a specific region" do
    expect(Ticket.region(region1.id)).to match_array([open_ticket, assigned_ticket, closed_ticket, closed_org_ticket, region_ticket, resource_ticket])
  end

  it "returns only tickets assigned to a specific resource category" do
    expect(Ticket.resource_category(resource1.id)).to match_array([open_ticket, assigned_ticket, closed_ticket, closed_org_ticket, region_ticket, resource_ticket])  
  end
    
  end

end
