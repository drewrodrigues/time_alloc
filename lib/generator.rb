require_relative "category"
require_relative "schedule"
require "byebug"

# Generator is a utility class which creates a context between
# Schedule and Categories that allows the generation of events
# based upon available time and available time slots given
# by Schedule and Categories.
class Generator
  # generates events of each category based upon remaining_time_allocation
  # @return [Integer] amount of events created
  def self.generate
    clear_generated_events
    events_created = 0
    # TODO refactor

    Category.all.each do |category|
      until category.remaining_time_allocation <= 1
        slot = Schedule.available_time_slots.first
        if slot.duration <= category.remaining_time_allocation
          slot = Event.new(slot.start_time, slot.end_time,
                           category.title, generated: true)
        else
          slot = Event.new(slot.start_time,
                           slot.start_time + category.remaining_time_allocation,
                           category.title,
                           generated: true)
        end

        puts slot.duration

        if slot.save
          events_created += 1
        end
      end
    end

    events_created
  end

  def self.clear_generated_events
    Event.delete_generated
  end
end
