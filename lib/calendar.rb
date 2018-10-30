# TODO: add event collision detection (return false when can't add)
# Calendar is a container class to hold events. It handles
# adding and deleting events, as well as calculating available
# time to create more events from.
class Calendar
  attr_reader :events

  def initialize
    @events = []
  end

  # @param [Event] event to be added
  def add_event(event)
    return false unless can_add_event?(event)
    @events << event
  end

  # @param [Integer] id of event to delete
  def remove_event(id)
    @events.reject! {|e| e.id == id}
  end

  # @param [Integer] id of event to get
  def find_event(id)
    @events.find {|e| e.id == id}
  end

  # @return [Integer] number of events
  def event_count
    @events.count
  end

  # @return [Integer] minutes left over after non-available time deducted from day
  def available_time
    minutes_in_day - used_time 
  end

  def display 
    @events.sort_by {|e| e.start_time}.each {|e| puts e}
  end

  private

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
