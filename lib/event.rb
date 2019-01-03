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
  def self.create(start_time, end_time, title="Undefined")
    # TODO add @generated (to easily remove events -- options hash)
    # options = {title: "something", generated: false}
    # FIXME Event.new(time_range, title)
    event = Event.new(start_time, end_time, title)
    event.save
  end

  # TODO refactor the below search methods into IDable

  def self.ordered_by_start
    Event.all.sort_by { |e| e.start_time } # Event.order_by(:start_time)
    # Event.reject(<attribute>, :something)
    # Event.select(<attribute>, :something)
  end

  def self.display_all
    Event.ordered_by_start.each {|e| puts e}
  end

  def self.non_generated
    Event.all.reject { |event| event.generated }
  end

  def self.generated
    # TODO write spec for
    Event.all.select { |event| event.generated }
  end

  def self.with_title(title)
    Event.all.select { |event| event.title == title }
  end

  def self.delete_generated
    # TODO write spec for
    Event.generated.each { |event| Event.delete(event.id) }
  end

  include IDable

  attr_reader :start_time, :end_time, :title, :generated

  # Creates an Event.
  # @param [Float] start_time event start time represented as a decimal
  # @param [Float] end_time event end time represented as a decimal
  # @param [String] title event title
  def initialize(start_time, end_time, title="Undefined", options = {})
    default_options = { generated: false }
    options = (options.empty? ? default_options : options)

    self.start_time = start_time
    self.end_time = end_time
    self.title = title
    @generated = options[:generated] # TODO write spec for
  end

  def save
    validate_times # TODO: make CB methods to run validations on certain class methods
    collides_with_any_event? ? false : Event.add(self)
  end

  # @return [String] formatted Event in format: (id) <title>: <start_time>-<end_time>
  def to_s
    "(#{id}) #{title}        #{start_time}-#{end_time}           #{generated}"
  end

  def collides_with_any_event?
    Event.all.each do |other_event|
      return true if collides_with?(other_event)
    end
    false
  end

  def next_event
    Event.ordered_by_start.each do |e|
      return e if e.start_time >= self.end_time
    end
    Event.new(24, 24)
  end

  def title=(title)
    raise ArgumentError, "Title required" unless title.length > 0
    @title = title
  end
end
