# Contain hours and minutes without accounting for seconds to create a simple
# interface to add, substract and compare. Also, easily increment minutes
# without having to manually calculate seconds to minute conversions.

# TODO: implement AM/PM view option
# TODO: implement AM/PM input (parse the input differently if it has those arguments

class Clock
  include Comparable

  # Create a Time object at hours & minutes.
  # @param [Integer] hours amount of hours
  # @param [Integer] minutes amount of minutes
  def initialize(float)
    hours, minutes = float_to_hours_and_minutes(float)
    @time = Time.new(1, 1, 1, hours, minutes)
  end

  # @return [Integer] amount of hours
  def hour
    @time.hour
  end

  # @return [Integer] amount of minutes
  def minutes
    @time.min
  end

  # @param [Integer] mins minutes to add to Clock
  # @return [Clock] new Clock object with added minutes
  def +(mins)
    new_time = @time + minutes_to_seconds(mins % 60) + hours_to_seconds(mins / 60)
    Clock.new(clock_to_float(new_time))
  end

  # compare time
  def <=>(other)
    @time <=> other.time
  end

  # @param[Integer] other
  # @return [Integer] minutes between self and other clock
  def -(other)
    ((@time - other.time) / 60).to_i
  end

  # @return [String] formatted time, HH:MM
  def to_s
    "#{hour}:#{padded_minutes}"
  end

  def between?(start_time, end_time)
    self > start_time && self < end_time
  end

  private

  def minutes_to_seconds(mins)
    mins * 60
  end

  def hours_to_seconds(hours)
    hours * 60 * 60
  end

  def padded_minutes
    minutes > 9 ? minutes : '0' + minutes.to_s
  end

  # converts float into whole number section for hour and decimal section for minutes
  # @param [Float] float to be converted into hours.minutes
  # @return [Array] hours and minutes
  def float_to_hours_and_minutes(float)
    # TODO: pull out to have Clock to support it
    hours = float.to_i
    minutes = (float * 10 * 10 % 100).to_i
    raise ArgumentError, 'Minutes must be between 0-59' unless (0..59).cover?(minutes)
    [hours, minutes]
  end

  def clock_to_float(clock)
    clock.hour + clock.min * 0.01
  end

  protected

  attr_reader :time # TODO: review
end

