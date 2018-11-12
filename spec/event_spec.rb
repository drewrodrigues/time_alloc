require_relative '../lib/event'

class Event
  def self.reset_instance_cache
    @instances = []
    @next_id = 0
  end
end

RSpec.describe Event do
  before do
    Event.reset_instance_cache
  end

  describe "validations" do
    it "requires start_time" do
      expect {
        Event.new(nil, 5.45)
      }.to raise_error ArgumentError, "Start time required"
    end

    it "requires end_time" do
      expect {
        Event.new(5.45, nil)
      }.to raise_error ArgumentError, "End time required"
    end

    it "title has a default" do
      event = Event.new(4, 5)

      expect(event.title).to_not be nil
    end

    it "validates start_time <= end_time" do
      expect {
        Event.new(5, 2, "Something")
      }.to raise_error ArgumentError, "Start time must be before end time"
    end

    it "doesn't allow minutes over 59" do
      expect {
        Event.new(5.1, 5.60)
      }.to raise_error ArgumentError, "Minutes must be between 0-59"
    end
  end

  describe "#duration" do
    context "when 1 hour" do
      it "returns 60" do
        event = Event.new(5, 6)

        expect(event.duration).to eq(60)
      end
    end

    context "when 10 minutes" do
      it "returns 10" do
        event = Event.new(4, 4.1)

        expect(event.duration).to eq(10)
      end
    end
  end

  describe "#save" do
    context "when start_time between another events start & end time" do
      it "returns false" do
        event = Event.new(4, 5)
        event.save
        colliding_event = Event.new(4.3, 6)

        expect(colliding_event.save).to be false
      end
    end

    context "when end_time between another events start & end time" do
      it "returns false" do
        event = Event.new(4, 5)
        event.save
        colliding_event = Event.new(3, 4.3)

        expect(colliding_event.save).to be false
      end
    end

    context "when start & end time don't collide with other event" do
      it "returns truthy" do
        event = Event.new(4, 5)
        event.save
        other_event = Event.new(5, 6)

        expect(other_event.save).to be_truthy
      end
    end

    context "when both events have the same start and end time" do
      it "returns false" do
        event = Event.new(4, 5)
        event.save
        other_event = Event.new(4, 5)

        expect(other_event.save).to eq(false)
      end
    end
  end

  describe "#==" do
    context "when Events have the same start and end time" do
      it "returns true" do
        event = Event.new(1, 2)
        equal_event = Event.new(1, 2)

        expect(event).to eq(equal_event)
      end
    end

    context "when Events have different start times" do
      it "returns false" do
        event = Event.new(1, 3)
        different_event = Event.new(2, 3)

        expect(event).to_not eq(different_event)
      end
    end

    context "when Events have different end times" do
      it "returns false" do
        event = Event.new(1, 2)
        different_event = Event.new(1, 3)

        expect(event).to_not eq(different_event)
      end
    end

    context "when Events have different start and end times" do
      it "returns false" do
        event = Event.new(0, 2)
        different_event = Event.new(5, 8)

        expect(event).to_not eq(different_event)
      end
    end
  end
end

