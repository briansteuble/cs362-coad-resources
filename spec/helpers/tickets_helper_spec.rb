require 'rails_helper'

RSpec.describe TicketsHelper, type: :helper do
  it "formats a phone number" do
    expect(helper.format_phone_number("+1 555-555-5555"))
      .to eq "+15555555555"
  end

  it "stubs PhonyRails.normalize_number for demonstration" do
    allow(PhonyRails).to receive(:normalize_number)
      .with("Fake Input", country_code: "US")
      .and_return("+19998887777")

    result = helper.format_phone_number("Fake Input")
    expect(result).to eq("+19998887777")
  end
end
