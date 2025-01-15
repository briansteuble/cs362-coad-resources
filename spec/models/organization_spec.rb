require 'rails_helper'

RSpec.describe Organization, type: :model do

  let (:org) {Organization.new}

  it "exists" do
    Organization.new
  end

  it "responds to name" do
    expect(org).to respond_to(:name)
  end

  it "responds to status" do
    expect(org).to respond_to(:status)
  end

  it "responds to phone" do
    expect(org).to respond_to(:phone)
  end

  it "responds to email" do
    expect(org).to respond_to(:email)
  end

  it "responds to description" do
    expect(org).to respond_to(:description)
  end

  it "responds to rejection_reason" do
    expect(org).to respond_to(:rejection_reason)
  end

  it "responds to liability_insurance" do
    expect(org).to respond_to(:liability_insurance)
  end

  it "responds to primary_name" do
    expect(org).to respond_to(:primary_name)
  end

  it "responds to secondary_name" do
    expect(org).to respond_to(:secondary_name)
  end

  it "responds to title" do
    expect(org).to respond_to(:title)
  end

  it "responds to transportation" do
    expect(org).to respond_to(:transportation)
  end

  ###############################################

  #### Organizations has many users
  it "has many users" do
    should have_many(:users)
  end

  it "has many tickets" do
    should have_many(:tickets)
  end

  it "has and belongs to many resource_categories" do
    should have_and_belong_to_many(:resource_categories)
  end
  #####################################################
end
