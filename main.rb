require_relative "lib/calendar"
require_relative "lib/event"

class Main
  def initialize
    @calendar = Calendar.new
    loop do
      run
    end
  end

  def run
    prompt
    puts @calendar
    input = gets.chomp
    
    case input
    when "1"
      add_event
    when "2"
      remove_event
    else
      puts "Bad input: press <enter> to continue"
      gets
    end

  end

  private

  def add_event
    puts "Example: 1.30 is equivalent to 1:30, or 23:40 is equivalent to 11:40PM"
    print "Start time: "
    start_time = gets.chomp.to_f
    print "End time: "
    end_time = gets.chomp.to_f
    print "Title: "
    title = gets.chomp
    event = Event.new(start_time, end_time, title)

    @calendar.add_event(event)
  end

  def remove_event
    print "ID of event: "
    id = gets.chomp.to_i

    @calendar.remove_event(id)
  end

  def prompt
    puts "<1> Add event"
    puts "<2> Delete event"
  end
end

Main.new
