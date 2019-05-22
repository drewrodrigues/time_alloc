require_relative "modules/idable"
require_relative "schedule"

# Top level documentation goes here
# TODO: allow creation with minutes instead of percentage
# TODO: write documentation
class Category
  def self.display_all
    puts("ID".ljust(5) + "Title".ljust(20) + "Percentage".ljust(15) +
         "Used/Allocated".ljust(20))
    Category.all.each { |c| puts c }
  end

  # TODO: make instance method
  def self.can_add_category?(category)
    total_percent = Category.all.reduce(0) { |total, c| total + c.percentage }
    total_percent + category.percentage <= 1.0
  end

  include IDable

  attr_reader :title, :percentage

  # create a Category with a 'Undefined' title and 0.0 percentage
  def initialize(title = "Undefined", percentage = 0.0)
    self.title = title
    self.percentage = percentage
  end

  def save
    return false unless Category.can_add_category?(self)

    Category.add(self)
  end

  def to_s
    "##{id}".ljust(5) + title.ljust(20) +
      "#{(percentage * 100).to_i}\%".ljust(15) +
      "#{used_time_allocation.to_i}/#{time_allocation.to_i}".ljust(20)
  end

  def time_allocation
    Schedule.time_for_generation * percentage
  end

  def remaining_time_allocation
    time_allocation - used_time
  end

  def used_time_allocation
    time_allocation - remaining_time_allocation
  end

  def ==(other)
    title == other.title
  end

  private

  def used_time
    Event.with_title(title).reduce(0) { |total, e| total + e.duration }
  end

  def title=(title)
    unless title.length.between?(1, 20)
      raise ArgumentError, "Title must be between 1-20"
    end

    @title = title
  end

  def percentage=(percentage)
    unless percentage.between?(0.01, 1.0)
      raise ArgumentError, "Percentage must be between 0.01-1.0"
    end

    @percentage = percentage.round(2)
  end
end
