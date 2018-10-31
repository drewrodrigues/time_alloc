require_relative "lib/calendar"
require_relative "lib/event"
require_relative "lib/category"

class Main
  def initialize
    @calendar = Calendar.new
    loop do
      run
    end
  end

  def run
    system "clear"
    @calendar.display
    input = prompt 
    
    puts "\n\n"
    case input
    when "1"
      add_event
    when "2"
      remove_event
    when "3"
      add_category
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

    begin
      event = Event.new(start_time, end_time, title)
      @calendar.add_event(event)
      puts "Event successfully added!"
      puts "Event couldn't be added"
    rescue ArgumentError => e # TODO: implement validation error, to specifically rescue those
      puts e
      gets
    end
  end

  def remove_event
    print "ID of event: "
    id = gets.chomp.to_i

    @calendar.remove_event(id) # TODO: explicitly rescue validation errors
  end

  def prompt
    puts "\n"
    puts "<1> Add event"
    puts "<2> Delete event"
    puts "<3> Add category"
    gets.chomp
  end

  def add_category
    title = ""
    while title.empty?
      print "Category title: "
      title = gets.chomp
    end

    percentage = 0.0
    until percentage >= 0.01 && percentage <= 1.0 
      print "Category percentage (ex: 0.5 = 50%):"
      percentage = gets.chomp.to_f
    end

    category = Category.new(title, percentage)
    @calendar.add_category(category)
  end

  def remove_category
    print "ID of category: "
    id = gets.chomp.to_i

    @calendar.remove_category(id)
  end
end

if $PROGRAM_NAME == __FILE__
  Main.new
end
