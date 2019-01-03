require_relative "clock"

# TODO delegate methods from event to this
class ClockRange
  attr_reader :start_time, :end_time

  def initialize(start, end)

  end

  # @return [Integer] the duration of event in minutes
  def duration
    end_time - start_time
  end

  def +(other)
    duration + other.duration
  end

  # Checks to see if hours and time are equal
  def ==(other)
    return false unless other.is_a?(Event)
    start_time == other.start_time && end_time == other.end_time
  end

  private

  def collides_with?(event)
    return true if self == event
    event.start_time.between?(start_time, end_time) ||
      event.end_time.between?(start_time, end_time)
  end

  def start_time=(start_time)
    raise ArgumentError, "Start time required" if start_time.nil?
    # TODO: pull out method below into a method
    @start_time = (start_time.is_a?(Clock) ? start_time : Clock.new(start_time))
  end

  def end_time=(end_time)
    raise ArgumentError, "End time required" if end_time.nil?
    # TODO: pull out method below into a method
    @end_time = (end_time.is_a?(Clock) ? end_time : Clock.new(end_time))
  end

  def validate_times
    return if start_time.zeroed? || end_time.zeroed?
    unless start_time <= end_time
      raise ArgumentError, "Start time must be before end time"
    end
  end
end
