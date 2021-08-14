require_relative "../lib/schedule"
require_relative "../lib/event" # TODO: stub out completely (bad Andrew)

RSpec.describe Schedule do
  describe "#available_time" do
    context "when no events" do
      it "returns 24 hours in minutes" do
        expect(Schedule.available_time).to eq(24 * 60)
      end
    end

    context "when 8 hours in events" do
      it "returns 960" do
        event = Event.create(1, 9, "Something")

        expect(Schedule.available_time).to eq(960)
      end
    end

    context "when 24 hours in events" do
      it "returns 0 minutes" do
        event = Event.create(0, 12)
        event2 = Event.create(12, 24)

        expect(Schedule.available_time).to eq(0)
      end
    end
  end

  describe "#available_time_slots" do
    context "when no events" do
      it "returns the whole day" do
        expect(Schedule.available_time_slots).to eq([Event.new(0, 24)])
      end
    end

    context "when Event from 0-5" do
      it "returns Event from 5-24" do
        Event.create(0, 5)

        expect(Schedule.available_time_slots).to eq([Event.new(5, 24)])
      end
    end

    context "when Events from 1-10, 12-18:30, 22-24" do
      it "returns Events from 0-1, 10-12, 18:30-22" do
        Event.create(1, 10)
        Event.create(12, 18.3)
        Event.create(22, 24)

        expect(Schedule.available_time_slots).to eq([
          Event.new(0, 1),
          Event.new(10, 12),
          Event.new(18.3, 22)
        ])
      end
    end
  end
end
