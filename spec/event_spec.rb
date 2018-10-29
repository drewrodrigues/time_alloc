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

    it "available defaults to true" do
      event = Event.new(4, 5)

      expect(event.available).to be true
    end

    it "validates start_time < end_time" do
      expect {
        Event.new(5, 2, "Something")
      }.to raise_error ArgumentError, "Start time must be before end time"
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
end
