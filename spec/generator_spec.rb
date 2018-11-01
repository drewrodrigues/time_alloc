require_relative "../lib/generator"
require_relative "../lib/category"

RSpec.describe Generator do
  describe "#generate" do

  end

  describe "#add_category" do
    before do
      @generator = Generator.new(60 * 24)
    end

    context "when 1.0 in Categories" do
      it "returns false" do
        category = Category.new("Programming", 1.0)
        @generator.add_category(category)

        overflow_category = Category.new("Workout", 0.2)

        expect(@generator.add_category(category)).to be false
      end
    end

    context "when categories sum <= 1.0" do
      it "returns true" do
        category = Category.new("Programming", 0.8)
        @generator.add_category(category)
        another_category = Category.new("Workout", 0.2)

        expect(@generator.add_category(another_category)).to be_truthy
      end

      it "increments category_count by 1" do
        category = Category.new("Programming", 0.8)
        @generator.add_category(category)
        another_category = Category.new("Workout", 0.2)

        expect {
          @generator.add_category(another_category)
        }.to change(@generator, :category_count).by(1)
      end
    end
  end
end

