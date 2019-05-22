require_relative "../../lib/modules/idable"

class Mock
  include IDable
end

RSpec.describe IDable do
  before do
    Mock.reset_instance_cache
  end

  it "adds id" do
    expect(Mock.new.respond_to?(:id)).to be true
  end

  describe "#initialize" do
    it "assigns id to 1 less than length (starts at 0)" do
      mock = Mock.new
      expect(mock.id).to eq(Mock.count - 1)
    end

    it "increments count by 1" do
      expect do
        Mock.new
      end.to change(Mock, :count).by(1)
    end
  end

  describe ".add" do
    it "adds the instance to instances" do
      mock = Mock.new
      expect(Mock.all).to eq([mock])
    end

    it "increments count by 1" do
      expect do
        Mock.new
      end.to change(Mock, :count).by(1)
    end
  end

  describe ".delete" do
    context "when instance with ID exists" do
      it "decrements count by 1" do
        Mock.new

        expect do
          Mock.delete(0)
        end.to change(Mock, :count).by(-1)
      end
    end

    context "when no instance with ID exists" do
      it "returns nil" do
        expect(Mock.delete(100)).to be nil
      end
    end
  end

  describe ".find" do
    context "when instance with ID exists" do
      it "returns the instance" do
        mock = Mock.new

        expect(Mock.find(0)).to eq(mock)
      end
    end

    context "when no instance with ID exists" do
      it "returns nil" do
        expect(Mock.find(100)).to be nil
      end
    end
  end

  describe ".count" do
    context "when 1 instance" do
      it "returns 1" do
        Mock.new
        expect(Mock.count).to eq(1)
      end
    end

    context "when 0 instances" do
      it "returns 0" do
        expect(Mock.count).to eq(0)
      end
    end
  end

  describe ".all" do
    context "when no instances" do
      it "returns an empty array" do
        expect(Mock.all).to eq([])
      end
    end

    context "with instances" do
      it "returns all instances" do
        instances = []
        3.times { instances << Mock.new }

        instances.each do |instance|
          expect(Mock.all.include?(instance)).to be true
        end
      end
    end

    context "with instances from different classes" do
      it "only returns the instances from it's class" do
        mock = Mock.new
        Class.new.include(IDable).new

        expect(Mock.all).to eq([mock])
      end
    end
  end
end
