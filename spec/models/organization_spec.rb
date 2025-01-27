require 'rails_helper'

RSpec.describe Organization, type: :model do

  let (:org) {Organization.new}


  describe "attribute tests" do
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

    it "has many users" do
      should have_many(:users)
    end

    it "has many tickets" do
      should have_many(:tickets)
    end

    it "has and belongs to many resource_categories" do
      should have_and_belong_to_many(:resource_categories)
    end
  end

  describe "validation tests" do
    ## presence
    it "validates presence of email" do
      expect(org).to validate_presence_of(:email)
    end
    it "validates presence of name" do
      expect(org).to validate_presence_of(:name)
    end
    it "validates presence of phone" do
      expect(org).to validate_presence_of(:phone)
    end
    it "validates presence of status" do
      expect(org).to validate_presence_of(:status)
    end
    it "validates presence of primary_name" do
      expect(org).to validate_presence_of(:primary_name)
    end
    it "validates presence of secondary_name" do
      expect(org).to validate_presence_of(:secondary_name)
    end
    it "validates presence of secondary_phone" do
      expect(org).to validate_presence_of(:secondary_name)
    end

    it "validates email length" do
      expect(org).to validate_length_of(:email).is_at_most(255)
      expect(org).to validate_length_of(:email).is_at_least(1)
    end
    it "validates name length" do
      expect(org).to validate_length_of(:name).is_at_most(255)
      expect(org).to validate_length_of(:name).is_at_least(1)
    end

    it "validates description length" do
      expect(org).to validate_length_of(:description).is_at_most(1020)
    end

    it "validates uniqueness of email" do
      expect(org).to validate_uniqueness_of(:email).case_insensitive()
    end

    it "validates uniqueness of name" do
      expect(org).to validate_uniqueness_of(:name).case_insensitive()
    end

    it "validates format of email" do
      should allow_value('example@gmail.com').for(:email)
    end

  end

  describe "member function tests" do
    it "sets status to 'approved'" do
      org.approve
      expect(org.status).to eq "approved"
    end
  
    it "sets status to 'rejected'" do
      org.reject
      expect(org.status).to eq "rejected"
    end
  
    it "sets default status to 'submitted'" do
      new_org = Organization.new
      new_org.set_default_status
      expect(new_org.status).to eq "submitted"
    end
  
    it "outputs name as string" do
      org.name = "Test Organization"
      expect(org.to_s).to eq "Test Organization"
    end
  end

  




end
