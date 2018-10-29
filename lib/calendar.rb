class Calendar
  attr_reader :events

  def initialize
    @events = []
  end

  def add_event(event)
    @events << event
  end

  def remove_event(id)
    @events.reject! {|e| e.id == id}
  end

  def event_count
    @events.count
  end

  def available_time
    @events.inject(0) {|total, e| total + e.duration}
  end
end
