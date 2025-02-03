require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it "returns base title when no page title is provided" do
    expect(helper.full_title).to eq "Disaster Resource Network"
  end

  it "returns formatted title when a page title is provided" do
    expect(helper.full_title("Dashboard")).to eq "Dashboard | Disaster Resource Network"
  end
  

end
