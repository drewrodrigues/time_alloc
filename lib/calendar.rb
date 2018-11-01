# Calendar is a container class to hold events and categories. It handles
# adding and deleting events, as well as calculating available
# time to create more events from.

# TODO: write automatic methods that reallocate_times and available_time slots on certain actions

class Calendar
  attr_reader :events

  # setup events to hold
  def initialize
    @events = []
    @categories = []
  end

  # @param [Event] event to be added
  # TODO: support adding multiple events
  def add_event(event)
    return false unless can_add_event?(event)
    @events << event
    reallocate_times # TODO: remove duplication
  end

  # @param [Integer] id of event to delete
  def remove_event(id)
    reallocate_times if @events.reject! {|e| e.id == id}
  end

  # @param [Integer] id of event to get
  def find_event(id)
    @events.find {|e| e.id == id}
    # TODO: pull into module (IDable#delete)
  end

  # @return [Integer] number of events
  def event_count
    @events.count
    # TODO: change count to IDable module
    # TODO: instead of keeping instances of IDable classes in the calendar, reference them from IDable's class all method
  end

  # @return [Integer] minutes left over after non-available time deducted from day
  def available_time
    minutes_in_day - used_time 
  end

  # show events ordered by start_time
  def display 
    puts "Categories"
    puts "-" * 20
    @categories.sort_by {|c| c.title}.each {|e| puts e}

    puts "\nAvailability"
    puts "-" * 20
    # TODO: create sort_by(&:start_time) hethod (proc?)
    available_time_slots.sort_by {|c| c.start_time}.each {|e| puts e}

    puts "\n"
    puts "Events"
    puts "-" * 20
    @events.sort_by {|e| e.start_time}.each {|e| puts e}
  end

  # TODO: finish writing specs
  # TODO: write documentation
  def available_time_slots
    slots = []
    prev_event = Event.new(0, 0) 
    end_of_day = Event.new(24, 24)
 
    until prev_event == end_of_day
      next_event = event_after(prev_event)
      possible_available_time_slot = Event.new(prev_event.end_time, next_event.start_time)

      if possible_available_time_slot.duration.positive?
        slots << possible_available_time_slot
      end

      prev_event = next_event
    end

    slots
  end

  # TODO: write specs
  def available_time # TODO change to available minutes_in_day
    minutes_in_day - used_time
  end

  private

  def event_after(event)
    ordered_events.each do |e|
      return e if e.start_time >= event.end_time
    end
    Event.new(24, 24)
  end

  # TODO
  # Pull out into class method
  def ordered_events
    @events.sort_by {|e| e.start_time}
  end

  # TODO
  # Pull out into class method
  # IDable holds instances, then sort based upon that
  def events_in_order
    @events.sort_by {|e| e.start_time}
  end

  def can_add_event?(event)
    @events.each do |e|
      return false if event.collides_with?(e)
    end
    true
  end

  def used_time 
    @events.inject(0) {|total, e| total + e.duration}
  end

  def minutes_in_day
    24 * 60
  end
end
