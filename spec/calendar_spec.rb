require_relative "../lib/calendar"

RSpec.describe Calendar do
  before do
    @calendar = Calendar.new
  end

  describe "#add_event" do
    it "increments event_count by 1" do
      @calendar.add_event(double("event"))
    end
  end

  describe "#event_count" do
    context "when no events" do
      it "returns 0" do
        expect(@calendar.event_count).to eq(0)
      end
    end

    it "returns the amount of events" do
      @calendar.add_event(double('event'))

      expect(@calendar.event_count).to eq(1)
    end
  end

  describe "#available_time" do
    before do
      @calendar = Calendar.new
    end

    context "when no events" do
      before do
        @calendar.add_event
      end

      it "returns 24 hours in minutes" do
        expect(@calendar.available_time)
      end
    end

    context "when events" do
      before do
      end
    end

    context "when 1 unavailable event" do
      it "returns 24 hours in minutes"
    end
  end
end
