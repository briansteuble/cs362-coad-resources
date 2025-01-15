require 'rails_helper'

RSpec.describe Region, type: :model do

  let (:reg) {Region.new}
  it "exists" do
    Region.new
  end

  it "responds to name" do
    expect(reg).to respond_to(:name)
  end

  it "has many tickets" do
    should have_many(:tickets)
  end

  it "has a string representation that is its name" do
    name = 'Mt. Hood'
    region = Region.new(name: name)
    result = region.to_s
  end

end
