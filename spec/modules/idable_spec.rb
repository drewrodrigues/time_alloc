require_relative "../../lib/modules/idable"

# TODO: make class variables wipe after each spec
# they are persisting on each spec
class Mock
  include IDable
end

RSpec.describe IDable do
  it "adds id" do
    expect(Mock.new.respond_to?(:id)).to be true
  end
  
  describe "#assign_id" do
    it "assigns id to 1 less than length (starts at 0)" do
      mock = Mock.new

      expect(mock.id).to eq(mock.count - 1)
    end
  end
end
