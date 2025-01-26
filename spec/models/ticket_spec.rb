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

#validates_presence_of :name, :phone, :region_id, :resource_category_id
#validates_length_of :name, minimum: 1, maximum: 255, on: :create
#validates_length_of :description, maximum: 1020, on: :create
#validates :phone, phony_plausible: true

describe "validation tests" do

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

  it "scopes closed tickets" do
    region = Region.create!(name: "region1")
    resource = ResourceCategory.create!(name: "resource1")

    ticket = Ticket.create!(
      name: "ticket",
      phone: "+1-555-555-5555",
      region_id: region.id,
      resource_category_id: resource.id,
      closed: true
  )

    expect(Ticket.closed).to include(ticket)
    expect(Ticket.open).to_not include(ticket)
    end

  it "scopes open tickets" do
    region = Region.create!(name: "region1")
    resource = ResourceCategory.create!(name: "resource1")
  
    ticket = Ticket.create!(
      name: "ticket",
      phone: "+1-555-555-5555",
      region_id: region.id,
      resource_category_id: resource.id,
      closed: false,
      organization_id: nil
  )
  
    expect(Ticket.closed).to_not include(ticket)
    expect(Ticket.open).to include(ticket)  
    end

    
  end

end

