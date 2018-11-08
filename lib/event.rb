require_relative "./modules/idable"
require_relative "./clock"

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
    super()
    self.start_time = start_time
    self.end_time = end_time
    self.title = title
    validate_times
  end

  # @return [Integer] the duration of event in minutes
  def duration
    end_time - start_time
  end

  # @return [String] formatted Event in format: (id) <title>: <start_time>-<end_time>
  def to_s
    "(#{id}) #{title}: #{start_time}-#{end_time}"
  end

  # Check whether an event's start_time or end_time is between the other events start & end time (exclusive range).
  # @param [Event] event event to check if times collide
  # @return [Boolean] whether the start_time or end_time is between the other events start & end time
  def collides_with?(event)
    return true if self == event
    event.start_time > start_time && event.start_time < end_time || event.end_time > start_time && event.start_time < end_time
  end

  # Checks to see if hours and time are equal
  def ==(other)
    start_time == other.start_time && end_time == other.end_time
  end

  private

  def start_time=(start_time)
    raise ArgumentError, "Start time required" if start_time.nil?
    if start_time.is_a?(Clock)
      @start_time = start_time
    else
      hours, minutes = float_to_hours_and_minutes(start_time) # TODO: add support for passing clock Object
      @start_time = Clock.new(hours, minutes) 
    end
  end

  def end_time=(end_time)
    raise ArgumentError, "End time required" if end_time.nil?
    if end_time.is_a?(Clock)
      @end_time = end_time
    else
      hours, minutes = float_to_hours_and_minutes(end_time)
      @end_time = Clock.new(hours, minutes)
    end
  end

  def title=(title)
    raise ArgumentError, "Title required" unless title.length > 0 
    @title = title
  end

  def validate_times
    raise ArgumentError, "Start time must be before end time" unless start_time <= end_time
  end

  # converts float into whole number section for hour and decimal section for minutes
  # @param [Float] float to be converted into hours.minutes 
  # @return [Array] hours and minutes
  def float_to_hours_and_minutes(float)
    hours = float.to_i
    minutes = (float * 10 * 10 % 100).to_i
    raise ArgumentError, "Minutes must be between 0-59" unless (0..59).include?(minutes)
    [hours, minutes]
  end
end
