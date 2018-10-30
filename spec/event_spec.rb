require_relative '../lib/event'

RSpec.describe Event do
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

    it "validates start_time < end_time" do
      expect {
        Event.new(5, 2, "Something")
      }.to raise_error ArgumentError, "Start time must be before end time"
    end

    it "validates start_time != end_time" do
      expect {
        Event.new(5, 5)
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

  describe "#collides_with?" do
    context "when start_time between another events start & end time" do
      it "returns true" do
        event = Event.new(4, 5)
        colliding_event = Event.new(4.3, 6)

        expect(colliding_event.collides_with?(event)).to be true
      end
    end

    context "when end_time between another events start & end time" do
      it "returns true" do
        event = Event.new(4, 5)
        colliding_event = Event.new(3, 4.3)

        expect(colliding_event.collides_with?(event)).to be true
      end
    end

    context "when start & end time don't collide with other event" do
      it "returns false" do
        event = Event.new(4, 5)
        other_event = Event.new(5, 6)

        expect(other_event.collides_with?(event)).to be false 
      end
    end

    context "when both events have the same start and end time" do
      it "returns true" do
        event = Event.new(4, 5)
        other_event = Event.new(4, 5)

        expect(other_event.collides_with?(event)).to be true
      end
    end
  end
end

