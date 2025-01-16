require 'rails_helper'

RSpec.describe Ticket, type: :model do

  let (:tick) {Ticket.new}

  it "exists" do
    Ticket.new
  end

  it "responds to name" do
    expect(tick).to respond_to(:name)
  end

  it "responds to description" do
    expect(tick).to respond_to(:description)
  end

  it "responds to phone" do
    expect(tick).to respond_to(:phone)
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