# wrap Time class, add methods to easily create times,
# and easily add minutes to a time without having to calculate seconds etc
require "byebug"

class Clock
  include Comparable 

  def initialize(hours, minutes=0)
    @time = Time.new(1, 1, 1, hours, minutes)
  end

  def hour
    @time.hour
  end

  def minutes
    @time.min
  end
  
  def +(mins)
    new_time = @time + minutes_to_seconds(mins % 60) + hours_to_seconds(mins / 60)
    Clock.new(new_time.hour, new_time.min)
  end

  def <=>(other)
    @time <=> other.time 
  end

  def -(other)
    @time - other.time
  end

  private

  def minutes_to_seconds(mins)
    mins * 60
  end

  def hours_to_seconds(hours)
    hours * 60 * 60
  end

  protected

  attr_reader :time
end
