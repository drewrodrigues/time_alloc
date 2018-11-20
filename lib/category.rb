require_relative "modules/idable"
require_relative "schedule"

# TODO: write documentation
class Category
  include IDable

  attr_reader :title, :percentage

  # create a Category with a 'Undefined' title and 0.0 percentage
  def initialize(title="Undefined", percentage=0.0)
    self.title = title
    self.percentage = percentage
  end

  def save
    Category.add(self)
  end

  def to_s
    "(#{id}) #{title}: #{(percentage*100).to_i}% [#{time_allocation} minutes]"
  end

  def time_allocation
    Schedule.available_time * percentage
  end

  def self.display_all
    Category.all.each {|c| puts c}
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
