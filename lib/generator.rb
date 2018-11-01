require_relative "calendar"

class Generator
  attr_accessor :available_time

  def initialize(available_time)
    @categories = []
    @available_time = available_time
  end

  def reallocate_times
    @categories.each do |c|
      c.time_allocation = (@available_time * c.percentage).to_i
    end
  end

  def display
    puts "Categories"
    puts "-" * 20
    @categories.sort_by {|c| c.title}.each {|e| puts e}
  end

  # @return [Integer] number of categories
  def category_count
    @categories.count
  end

  # @param [Category] category to be added
  def add_category(category)
    return false unless can_add_category?(category)
    @categories << category
    reallocate_times
  end


  # TODO: write documentation
  def remove_category(id)
    @categories.reject! {|c| c.id == id}
  end

  private

  # TODO
  # make more clear whats happening (better variables)
  def can_add_category?(category)
    total_percent = @categories.inject(0) {|total, c| total + c.percentage}
    total_percent + category.percentage <= 1.0
  end

=begin
  we will initiate this with available_time_slots from Calendar
=end
end

