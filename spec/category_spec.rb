require_relative "../lib/category"

RSpec.describe Category do
  let(:valid_category) { Category.new("Programming", 0.5) }

  it "has a title" do
    expect(valid_category.respond_to?(:title)).to be true
  end

  it "has a percentage" do
    expect(valid_category.respond_to?(:percentage)).to be true
  end

  describe "validations" do
    describe "title" do
      context "when length 0 or 21" do
        it "raises an error" do
          ["", "s" * 21].each do |invalid_title|
            expect {
              Category.new(invalid_title, 0.5)
            }.to raise_error ArgumentError
          end
        end
      end
    end

    describe "percentage" do
      context "when 0.0" do
        it "raises ArgumentError" do
          expect {
            Category.new("Title", 0.0)
          }.to raise_error ArgumentError
        end
      end

      context "when < 0.0" do
        it "raises ArgumentError" do
          expect {
            Category.new("Title", -0.1)
          }.to raise_error ArgumentError
        end
      end

      context "when 1.0" do
        it "returns truthy" do
          expect(Category.new("Title", 1.0)).to be_truthy
        end
      end

      context "when > 1.0" do
        it "raises ArgumentError" do
          expect {
            Category.new("Title", 1.1)
          }.to raise_error ArgumentError
        end
      end

      context "when more than 2 point precision" do
        it "automaticaly strips off extrap precision" do
          category = Category.new("Title", 0.123)

          expect(category.percentage).to eq(0.12)
        end
      end
    end
  end
end
