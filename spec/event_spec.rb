require_relative "../lib/event"

RSpec.describe Event do
  let(:non_generated_event) do
    event = Event.new(1, 2, "Non generated")
    event.save
    event
  end

  let(:generated_event) do
    event = Event.new(3, 4, "Generated", generated: true)
    event.save
    event
  end

  describe "::ordered_by_start" do
    it "returns an ordered Array of Events" do
      second_event = Event.new(1, 2)
      first_event = Event.new(0, 1)
      third_event = Event.new(2, 3)
      [second_event, first_event, third_event].each(&:save)
      expect(Event.ordered_by_start).to eq([
        first_event, second_event, third_event
      ])
    end

    context "when no events" do
      it "returns []" do
        expect(Event.ordered_by_start).to be_empty
      end
    end
  end

  describe "::non_generated" do
    context "when non_generated events" do
      it "returns array of non_generated events" do
        event = Event.new(1, 2, "Some event")
        event2 = Event.new(3, 4, "Some event")
        event.save
        event2.save
        expect(Event.non_generated).to include(event, event2)
      end
    end

    context "when no non_generated events" do
      it "returns []" do
        generated_event
        expect(Event.non_generated).to be_empty
      end
    end
  end

  describe "::generated" do
    context "when generated events" do
      it "returns array of generated events" do
        event = Event.new(1, 2, "Some event", generated: true)
        event2 = Event.new(3, 4, "Some event", generated: true)
        event.save
        event2.save
        expect(Event.generated).to include(event, event2)
      end
    end

    context "when no non_generated events" do
      it "returns []" do
        non_generated_event
        expect(Event.generated).to be_empty
      end
    end
  end

  describe "::with_title" do
    context "when events exist" do
      it "returns the events" do
        event = Event.new(1, 2, "Something")
        event.save
        event2 = Event.new(3, 4, "Something")
        event2.save
        expect(Event.with_title("Something")).to include(event, event2)
      end
    end

    context "when event doesn't exist" do
      it "returns []" do
        expect(Event.with_title("Anything")).to be_empty
      end
    end
  end

  describe "::delete_generated" do
    context "when generated event exists" do
      it "removes the event" do
        non_gen = non_generated_event
        generated_event
        Event.delete_generated
        expect(Event.all).to eq([non_gen])
      end
    end
  end

  describe "validations" do
    it "requires start_time" do
      expect do
        Event.new(nil, 5.45)
      end.to raise_error ArgumentError
    end

    it "requires end_time" do
      expect do
        Event.new(5.45, nil)
      end.to raise_error ArgumentError
    end

    it "title has a default" do
      event = Event.new(4, 5)
      expect(event.title).to_not be nil
    end

    it "validates start_time < end_time" do
      expect do
        Event.create(5, 2, "Something")
      end.to raise_error ArgumentError
    end

    it "doesn't allow minutes over 59" do
      expect do
        Event.new(5.1, 5.60)
      end.to raise_error ArgumentError
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
    context "when start_time between other events start & end time" do
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
