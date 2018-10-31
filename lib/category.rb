require_relative "modules/idable"

# Categories will
class Category
  include IDable

  attr_accessor :time_allocation
  attr_reader :title, :percentage

  # create a category with a 'Undefined' title and 0.0 percentage
  def initialize(title="Undefined", percentage=0.0)
    super()
    self.title = title
    self.percentage = percentage
    @time_allocation = 0
  end

  def to_s
    "(#{id}) #{title}: #{(percentage*100).to_i}% [#{time_allocation} minutes]"
  end

  private

  def title=(title)
    raise ArgumentError, "Title must be between 1-20" unless title.length.between?(1, 20)
    @title = title
  end
  
  def percentage=(percentage)
    raise ArgumentError, "Percentage must be between 0.01-1.0" unless percentage.between?(0.01, 1.0)
    @percentage = percentage.round(2)
  end
end
