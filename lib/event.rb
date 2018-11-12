require_relative "./modules/idable"
require_relative "./clock"
require "byebug"

# Event has a start_time and end_time, title and tells
# whether it's available time or not. (such as sleep)
# Telling whether the event is available will help
# calculate available time, and free time left.
# Events are required to have a start_time < end_time.
# Events can be created by floats, where the Integer portion
# is the hours, and the decimal portion being the minutes.
# For example: Event.new(4.3, 5.3) would be a event that spans
# from 4:30 to 5:30.
class Event
  include IDable

  attr_reader :start_time, :end_time, :title

  # Creates an Event.
  # @param [Float] start_time event start time represented as a decimal
  # @param [Float] end_time event end time represented as a decimal
  # @param [String] title event title
  def initialize(start_time, end_time, title="Undefined")
    self.start_time = start_time
    self.end_time = end_time
    self.title = title
    validate_times
  end

  def save
    collides_with_any_event? ? false : Event.add(self)
  end

  # @return [Integer] the duration of event in minutes
  def duration
    end_time - start_time
  end

  # @return [String] formatted Event in format: (id) <title>: <start_time>-<end_time>
  def to_s
    "(#{id}) #{title}: #{start_time}-#{end_time}"
  end

  # Checks to see if hours and time are equal
  def ==(other)
    return false unless other.is_a?(Event)
    start_time == other.start_time && end_time == other.end_time
  end

  private

  def collides_with_any_event?
    Event.all.each do |other_event|
      return true if collides_with?(other_event)
    end
    false
  end

  def collides_with?(event)
    return true if self == event
    event.start_time.between?(start_time, end_time) ||
      event.end_time.between?(start_time, end_time)
  end

  def start_time=(start_time)
    raise ArgumentError, "Start time required" if start_time.nil?
    @start_time = (start_time.is_a?(Clock) ? start_time : Clock.new(start_time))
  end

  def end_time=(end_time)
    raise ArgumentError, "End time required" if end_time.nil?
    @end_time = (end_time.is_a?(Clock) ? end_time : Clock.new(end_time))
  end

  def title=(title)
    raise ArgumentError, "Title required" unless title.length > 0 
    @title = title
  end

  def validate_times
    raise ArgumentError, "Start time must be before end time" unless start_time <= end_time
  end
end

