require_relative "../lib/calendar"
require_relative "../lib/event" # TODO: stub out completely (bad Andrew)

RSpec.describe Calendar do
  before do
    @calendar = Calendar.new
  end

  describe "#add_event" do
    context "when Event doesn't collide with another Event" do
      it "increments event_count by 1" do
        event = Event.new(4, 5)
        non_colliding_event = Event.new(5, 6)
        @calendar.add_event(event)

        expect {
          @calendar.add_event(non_colliding_event)
        }.to change(@calendar, :event_count).by(1)
      end
    end

    context "when Event collides with another Event" do
      it "returns false" do
        event = Event.new(4, 5)
        colliding_event = Event.new(4, 5)
        @calendar.add_event(event)

        expect(@calendar.add_event(colliding_event)).to be false
      end

      it "doesn't increment event_count" do
        event = Event.new(4, 5)
        non_colliding_event = Event.new(4, 5)
        @calendar.add_event(event)

        expect {
          @calendar.add_event(non_colliding_event)
        }.to change(@calendar, :event_count).by(0)
      end
    end
  end

  describe "#remove_event" do
    it "removes Event when present" do
      event = object_double('event', id: 1)
      @calendar.add_event(event)

      @calendar.remove_event(1)

      expect(@calendar.find_event(1)).to be_falsy
    end

    it "returns truthy when Event deleted" do
      event = object_double('event', id: 1)
      @calendar.add_event(event)

      expect(@calendar.remove_event(1)).to be_truthy
    end

    it "returns false when Event not deleted" do
      expect(@calendar.remove_event(1)).to be_falsy 
    end
  end

  describe "#find_event" do
    context "when event exists" do
      it "returns the event" do
        event = object_double('event', id: 1)
        @calendar.add_event(event)

        expect(@calendar.find_event(1)).to eq(event) 
      end
    end

    context "when event doesn't exist" do
      it "returns falsy" do
        expect(@calendar.find_event(1)).to be_falsy
      end
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
      it "returns 24 hours in minutes" do
        expect(@calendar.available_time).to eq(24 * 60)
      end
    end

    context "when 8 hours in events" do
      it "returns 960" do
        # TODO: how to completely stub out Event
        event = Event.new(1, 9, "Something", false)
        @calendar.add_event(event)

        expect(@calendar.available_time).to eq(960)
      end
    end

    context "when 24 hours in events" do
      it "returns 0 minutes" do
        # TODO: stub out Event
        event = Event.new(0, 12)
        event2 = Event.new(12, 24)
        @calendar.add_event(event)
        @calendar.add_event(event2)

        expect(@calendar.available_time).to eq(0)
      end
    end
  end
end
