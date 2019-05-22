require_relative "clock"
require_relative "event"
require_relative "modules/idable"

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
  # TODO pull out start_time & end_time to TimeRange and validate in there
  def self.create(start_time, end_time, title = "Undefined")
    # TODO add @generated (to easily remove events -- options hash)
    # options = {title: "something", generated: false}
    # FIXME Event.new(time_range, title)
    event = Event.new(start_time, end_time, title)
    event.save
  end

  def self.ordered_by_start
    Event.all.sort_by(&:start_time)
  end

  def self.display_all
    puts("ID".ljust(5) + "Title".ljust(20) + "Start - End  " +
         "Generated?".rjust(20))
    puts "-" * 58
    Event.ordered_by_start.each { |e| puts e }
  end

  def self.non_generated
    Event.all.reject(&:generated)
  end

  def self.generated
    Event.all.select(&:generated)
  end

  def self.with_title(title)
    Event.all.select { |event| event.title == title }
  end

  def self.delete_generated
    Event.generated.each { |event| Event.delete(event.id) }
  end

  include IDable

  attr_reader :start_time, :end_time, :title, :generated

  # Creates an Event.
  # @param [Float] start_time event start time represented as a decimal
  # @param [Float] end_time event end time represented as a decimal
  # @param [String] title event title
  def initialize(start_time, end_time, title = "Undefined", options = {})
    self.start_time = start_time
    self.end_time = end_time
    self.title = title
    self.generated = options[:generated] || false
  end

  def save
    validate_times
    collides_with_any_event? ? false : Event.add(self)
  end

  # @return [Integer] the duration of event in minutes
  def duration
    end_time - start_time
  end

  def +(other)
    duration + other.duration
  end

  # @return [String] formatted Event in format:
  # (id) <title>: <start_time>-<end_time>
  def to_s
    "##{id}".ljust(5) + title.ljust(20) + start_time.to_s.ljust(5) +
      " - " + end_time.to_s.ljust(5) +
      generated.to_s.rjust(20)
  end

  # Checks to see if hours and time are equal
  def ==(other)
    return false unless other.is_a?(Event)

    start_time == other.start_time && end_time == other.end_time
  end

  def collides_with_any_event?
    Event.all.each do |other_event|
      return true if collides_with?(other_event)
    end
    false
  end

  def next_event
    Event.ordered_by_start.each do |e|
      return e if e.start_time >= end_time
    end
    Event.new(24, 24)
  end

  def title=(title)
    raise ArgumentError, "Title required" if title.length.zero?

    @title = title
  end

  private

  attr_writer :generated

  # TODO pull out below into TimeRange
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

    if start_time >= end_time
      raise ArgumentError, "Start time must be before end time"
    end
  end
end
