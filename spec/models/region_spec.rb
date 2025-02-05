require 'rails_helper'

RSpec.describe Region, type: :model do

  let (:reg) { build(:region) }

  describe "attribute tests" do
    it "exists" do
      expect(build(:region)).to be_a(Region)
    end

    it "responds to name" do
      expect(reg).to respond_to(:name)
    end

    it "has many tickets" do
      should have_many(:tickets)
    end

    it "has a string representation that is its name" do
      reg.name = 'Mt. Hood'
      expect(reg.to_s).to eq 'Mt. Hood'
    end

  end

  describe "validation tests" do
    it "validates presence of name" do
      expect(reg).to validate_presence_of(:name)
    end

    it "validates name length" do
      expect(reg).to validate_length_of(:name).is_at_most(255)
      expect(reg).to validate_length_of(:name).is_at_least(1)
    end

    it "validates uniqueness of name" do
      expect(reg).to validate_uniqueness_of(:name).case_insensitive
    end
  end

  describe "member function tests" do
    it "outputs name as string" do
      reg.name = "Test Region"
      expect(reg.to_s).to eq "Test Region"
    end
  end

  describe "class function tests" do
    it "finds or creates an unspecified region" do
      unspecified = Region.unspecified
      expect(unspecified.name).to eq "Unspecified"
    end

    it "returns the existing unspecified region if it exists" do
      create(:region, name: "Unspecified")  
      expect(Region.unspecified.name).to eq "Unspecified"
    end
  end

end
