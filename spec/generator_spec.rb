require "category"
require "event"
require "generator"
require "schedule"
require "byebug"



RSpec.describe Generator do
  before do
    Category.reset_instance_cache
  end

  describe "#generate" do
    context "when Category's allocated time fits within the first available slot" do
      before do
        category = Category.new("Programming", 0.5)
        category.save
      end

      it "creates 1 event" do
        Generator.generate
        expect(Event.count).to eq(1)
      end

      it "returns 1" do
        expect(Generator.generate).to eq(1)
      end

      it "returns an event with duration of 720 minutes" do
        Generator.generate
        expect(Event.all.first.duration).to eq(720)
      end
    end

    context "when Category's allocated time doesn't fit within the first available slot" do
      before do
        @category = Category.new("Programming", 0.5)
        @category.save
        event = Event.new(0.3, 3.2, "Anything")
        event.save
      end

      it "creates 2 events" do
        Generator.generate
        # expected 3, since 1 manually created
        expect(Event.count).to eq(3)
      end

      it "returns 2" do
        expect(Generator.generate).to eq(2)
      end
    end

    context "when there's multiple Categories" do
      it "creates events which fit within each Category's allocation" do
        category_one = Category.new("Programming", 0.5)
        category_two = Category.new("Reading", 0.5)
        category_one.save
        category_two.save

        Generator.generate
        [category_one, category_two].each do |category|
          expect(category.used_time_allocation).to eq(category.time_allocation)
        end
      end
    end
  end
end
