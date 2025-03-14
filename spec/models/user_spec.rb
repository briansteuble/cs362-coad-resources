require 'rails_helper'

RSpec.describe User, type: :model do

  let (:user) { build(:user, email: "example@gmail.com") }
  let (:admin_user) {build(:user, :admin) }
  let (:org_user) { build(:user, :with_organization) }

  describe "attributes test" do

  it "exists" do
    expect(user).to be_a(User)
  end

  it "responds to email" do
    expect(user).to respond_to(:email)
  end

  it "responds to role" do
    expect(user).to respond_to(:role)
  end

  it "can belong to organization" do
    should belong_to(:organization).optional
  end
end

#validates_presence_of :email
#validates_length_of :email, minimum: 1, maximum: 255, on: :create
#validates :email, format: { with: VALID_EMAIL_REGEX }
#validates_uniqueness_of :email, case_sensitive: false
#validates_presence_of :password, on: :create
#validates_length_of :password, minimum: 7, maximum: 255, on: :create

  describe "validation tests" do

    it "validates presence of email" do
      expect(user).to validate_presence_of(:email)
    end

    it "validates presence of password" do
      expect(user).to validate_presence_of(:password)
    end

    it "validates email length" do
      expect(user).to validate_length_of(:email).is_at_least(1)
      expect(user).to validate_length_of(:email).is_at_most(255)
    end

    it "validates password length" do
      expect(user).to validate_length_of(:password).is_at_least(7)
      expect(user).to validate_length_of(:password).is_at_most(255)
    end

    it "validates uniqueness of email" do
      expect(user).to validate_uniqueness_of(:email).case_insensitive
    end

    it "validates format of email" do
      should allow_value('example@gmail.com').for(:email)
    end

  end

  describe "role based tests" do

    it "sets default user role to :organizition" do
      user.set_default_role
      expect(user.role).to eq("organization")
    end

    it "creates an admin user with role :admin" do
      expect(admin_user.role).to eq("admin")
    end

    it "creates an organization user with role :organization" do
      expect(user.role).to eq("organization")
    end

    it "creates a user with an associated organization" do
      expect(org_user.organization).to be_present
    end

  end

  describe "member function tests" do

    it "converts user email to string" do
      expect(user.to_s).to eq("example@gmail.com")
    end

  end

end
