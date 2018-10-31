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
  def initialize(hours, minutes=0)
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
    Clock.new(new_time.hour, new_time.min)
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

  protected

  attr_reader :time # TODO: review
end

