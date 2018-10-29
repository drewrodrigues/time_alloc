require_relative "./modules/idable"
require_relative "./clock"

class Event
  include IDable

  # TODO: use clock for start_time & end_time
  attr_reader :start_time, :end_time, :title, :available

  def initialize(start_time, end_time, title="Undefined", available=true)
    self.start_time = start_time
    self.end_time = end_time
    self.title = title
    self.available = available
    validate_times
  end

  def duration
    (end_time - start_time).to_i
  end

  private

  def start_time=(start_time)
    raise ArgumentError, "Start time required" if start_time.nil?
    @start_time = Clock.new(start_time) 
  end

  def end_time=(end_time)
    raise ArgumentError, "End time required" if end_time.nil?
    @end_time = Clock.new(end_time)
  end

  def title=(title)
    raise ArgumentError, "Title required" unless title.length > 0 
    @title = title
  end

  def available=(available)
    raise ArgumentError, "Boolean required" unless available == true || available == false
    @available = available 
  end

  def validate_times
    raise ArgumentError, "Start time must be before end time" if start_time > end_time
  end
end
