require_relative "category"
require_relative "schedule"

# Generator is a utility class which creates a context between
# Schedule and Categories that allows the generation of events
# based upon available time and available time slots given
# by Schedule and Categories.
class Generator
  def can_add_category?(category)
    total_percent = Category.all.inject(0) {|total, c| total + c.percentage}
    total_percent + category.percentage <= 1.0
  end
end

