require 'rails_helper'

RSpec.describe ResourceCategory, type: :model do

  let (:rec) { build(:resource_category) }
  describe "attribute tests" do
    it "exists" do
      expect(build(:resource_category)).to be_a(ResourceCategory)
    end

    it "responds to name" do
      expect(rec).to respond_to(:name)
    end

    it "responds to active" do
      expect(rec).to respond_to(:active)
    end

    it "has and belongs to many organizations" do
      should have_and_belong_to_many(:organizations)
    end

    it "has many tickets" do
      should have_many(:tickets)
    end
  end

  describe "validation tests" do
    it "validates presence of name" do
      expect(rec).to validate_presence_of(:name)
    end

    it "validates name length" do
      expect(rec).to validate_length_of(:name).is_at_most(255)
      expect(rec).to validate_length_of(:name).is_at_least(1)
    end

    it "validates uniqueness of name" do
      expect(rec).to validate_uniqueness_of(:name).case_insensitive
    end
  end

  describe "member function tests" do
    it "outputs name as string" do
      rec.name = "Test Resource"
      expect(rec.to_s).to eq "Test Resource"
    end

    it "activates the resource category" do
      rec.activate
      expect(rec.active).to be true
    end

    it "deactivates the resource category" do
      rec.deactivate
      expect(rec.active).to be false
    end

    it "returns true when inactive" do
      rec.active = false
      expect(rec.inactive?).to be true
    end

    it "returns false when active" do
      rec.active = true
      expect(rec.inactive?).to be false
    end
  end

  describe "class function tests" do
    it "finds or creates an unspecified resource category" do
      unspecified = ResourceCategory.unspecified
      expect(unspecified.name).to eq "Unspecified"
    end

    it "returns the existing unspecified resource category if it exists" do
      create(:resource_category, name: "Unspecified")  
      expect(ResourceCategory.unspecified.name).to eq "Unspecified"
    end
  end

  describe "scope tests" do
    it "scopes active resource categories" do
      active_category = create(:resource_category, name: "Active Category", active: true)
      inactive_category = create(:resource_category, name: "Inactive Category", active: false)

      expect(ResourceCategory.active).to include(active_category)
      expect(ResourceCategory.active).to_not include(inactive_category)
    end

    it "scopes inactive resource categories" do
      active_category = create(:resource_category, name: "Active Category", active: true)
      inactive_category = create(:resource_category, name: "Inactive Category", active: false)

      expect(ResourceCategory.inactive).to include(inactive_category)
      expect(ResourceCategory.inactive).to_not include(active_category)
    end
  end


end
