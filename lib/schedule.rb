require_relative "event"

# Schedule is a utility class which gives a context of all Events
# and how they relate to each other.
class Schedule
  # @return [Integer] minutes left over after used time deducted from day
  def self.available_time
    minutes_in_day - used_time
  end

  # @return [Integer] minutes for generating Events
  def self.time_for_generation
    minutes_in_day - manual_events_used_time
  end

  # TODO: cleanup method
  def self.available_time_slots
    slots = []
    prev_event = Event.new(0, 0)
    end_of_day = Event.new(24, 24)

    until prev_event == end_of_day
      next_event = prev_event.next_event
      possible_available_time_slot = Event.new(prev_event.end_time,
                                               next_event.start_time)

      if possible_available_time_slot.duration.positive?
        slots << possible_available_time_slot
      end

      prev_event = next_event
    end

    slots
  end

  def self.all_events_of_category(category)
    Event.all.select { |e| e.category == category }
  end

  def self.used_time
    Event.all.reduce(0) { |total, e| total + e.duration }
  end

  def self.minutes_in_day
    24 * 60
  end

  def self.manual_events_used_time
    Event.non_generated.reduce(0) { |total, e| total + e.duration }
  end
end
