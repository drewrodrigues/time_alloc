# Contain hours and minutes without accounting for seconds to create a
# simple interface to add, substract and compare. Also, easily
# increment minutes without having to manually calculate seconds to
# minute conversions.
class Clock
  include Comparable

  attr_reader :time

  # Create a Time object at hours & minutes.
  # @param [Float] float time of Clock in format HH.MM
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

  # @param [Integer] minutes to add to Clock
  # @return [Clock] new Clock object with added minutes
  def +(minutes)
    minutes = minutes.to_i
    additional_seconds = minutes_to_seconds(minutes % 60)
    additional_seconds += hours_to_seconds(minutes / 60)
    new_time = @time + additional_seconds
    Clock.new(clock_to_float(new_time))
  end

  # @param [Clock] other clock to compare against
  # compare time
  def <=>(other)
    @time <=> other.time
  end

  # @param[Clock] other Clock
  # @return [Integer] minutes between self and other clock
  def -(other)
    ((@time - other.time) / 60).to_i
  end

  # @return [String] formatted time, HH:MM
  def to_s
    "#{padded_hours}:#{padded_minutes}"
  end

  # @param[Clock] start_time
  # @param[Clock] end_time
  # @return [Boolean] whether self is exclusively between start_time
  # and end_time
  def between?(start_time, end_time)
    self > start_time && self < end_time
  end

  # returns true whenever at 0:00
  def zeroed?
    hour.zero? && minutes.zero?
  end

  private

  def minutes_to_seconds(mins)
    mins * 60
  end

  def hours_to_seconds(hours)
    hours * 60 * 60
  end

  def padded_minutes
    minutes > 9 ? minutes : "0" + minutes.to_s
  end

  def padded_hours
    hour > 9 ? hour : "0" + hour.to_s
  end

  # converts float into whole number section for hour and decimal
  # section for minutes
  # @param [Float] float to be converted into hours.minutes
  # @return [Array] hours and minutes
  def float_to_hours_and_minutes(float)
    # TODO: pull out to have Clock to support it
    hours = float.to_i
    minutes = (float * 10 * 10 % 100).round.to_i
    unless (0..59).cover?(minutes)
      raise ArgumentError, "Minutes must be between 0-59"
    end

    [hours, minutes]
  end

  def clock_to_float(clock)
    clock.hour + clock.min * 0.01
  end
end
