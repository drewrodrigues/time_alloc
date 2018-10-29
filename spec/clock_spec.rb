require_relative "../lib/clock"

RSpec.describe Clock do
  it "has a default of 0 minutes" do
    clock = Clock.new(5)

    expect(clock.minutes).to eq(0)
  end

  describe "#+" do
    it "adds the number of minutes" do
      clock = Clock.new(6)

      clock += 50

      expect(clock.minutes).to eq(50)
    end
    
    context "when combined minutes are 60 or over" do
      it "wraps the minutes" do
        clock = Clock.new(6, 59)

        clock += 2

        expect(clock.minutes).to eq(1)
      end

      it "adds an hour" do
        clock = Clock.new(6, 59)

        clock += 2

        expect(clock.hour).to eq(7)
      end
    end
  end
end
