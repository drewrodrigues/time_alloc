require_relative "../lib/clock"

RSpec.describe Clock do
  subject { Clock.new(5.27) }

  describe "#initialize" do
    context "when not given minutes" do
      it "defaults to 0 minutes" do
        clock = Clock.new(5)
        expect(clock.minutes).to eq(0)
      end
    end
  end

  describe "#hour" do
    it "returns the amount of hours" do
      expect(subject.hour).to eq(5)
    end
  end

  describe "#minutes" do
    it "returns the amount of minutes" do
      expect(subject.minutes).to eq(27)
    end
  end

  describe "#+" do
    it "adds the number of minutes" do
      clock = Clock.new(6)
      clock += 50
      expect(clock.minutes).to eq(50)
    end

    context "when combined minutes are 60 or over" do
      it "wraps the minutes" do
        clock = Clock.new(6.59)
        clock += 2
        expect(clock.minutes).to eq(1)
      end

      it "adds an hour" do
        clock = Clock.new(6.59)
        clock += 2
        expect(clock.hour).to eq(7)
      end
    end
  end

  describe "#<=>" do
    context "when less than other time" do
      it "returns -1" do
        other_time = subject + 10
        expect(subject.<=>other_time).to eq(-1)
      end
    end

    context "when greater than other time" do
      it "returns 1" do
        other_time = subject + 10
        expect(other_time.<=>subject).to eq(1)
      end
    end

    context "when equal to other time" do
      it "returns 0" do
        other_time = subject
        expect(subject.<=>other_time).to eq(0)
      end
    end
  end

  describe "#-" do
    before do
      @greater_time = Clock.new(5.2)
      @less_time = Clock.new(5.1)
    end

    context "when self greater than other" do
      before do
        @difference = @greater_time - @less_time
      end

      it "returns the difference" do
        expect(@difference).to eq(10)
      end

      it "returns positive difference" do
        expect(@difference).to be_positive
      end
    end

    context "when self less than other" do
      before do
        @difference = @less_time - @greater_time
      end

      it "returns the difference" do
        expect(@difference).to eq(-10)
      end

      it "returns negative difference" do
        expect(@less_time - @greater_time).to be_negative
      end
    end

    context "when both equal" do
      it "return 0" do
        expect(subject - subject).to eq(0)
      end
    end
  end

  describe "#to_s" do
    it "pads minutes" do
      expect(Clock.new(12.02).to_s).to eq("12:02")
    end

    it "pads hours" do
      expect(Clock.new(5.02).to_s).to eq("05:02")
    end
  end

  describe "#between?" do
    context "when between" do
      it "returns true" do
        start_time = Clock.new(subject.hour - 1)
        end_time = start_time + 100
        expect(subject.between?(start_time, end_time)).to be true
      end
    end

    context "when not between" do
      it "returns false" do
        start_time = subject + 100
        end_time = subject + 200
        expect(subject.between?(start_time, end_time)).to be false
      end
    end

    context "when start and end time equal" do
      it "returns false" do
        expect(subject.between?(subject, subject)).to be false 
      end
    end
  end

  describe "#zeroed?" do
    context "when both hours and minutes zero" do
      it "returns true" do
        expect(Clock.new(0.00).zeroed?).to be true
      end
    end

    context "when hours not zero and minutes zero" do
      it "returns false" do
        expect(Clock.new(5.00).zeroed?).to be false
      end
    end

    context "when hours zero and minutes not zero" do
      it "returns false" do
        expect(Clock.new(0.50).zeroed?).to be false
      end
    end
  end
end
