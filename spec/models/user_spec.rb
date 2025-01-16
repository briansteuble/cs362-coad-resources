require 'rails_helper'

RSpec.describe User, type: :model do

  let (:user) {User.new}

  it "exists" do
    User.new
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
