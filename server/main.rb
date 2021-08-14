require_relative "lib/category"
require_relative "lib/event"
require_relative "lib/generator"
require_relative "lib/schedule"

class Main
  def initialize
    @schedule = Schedule.new
    loop do
      run
    end
  end

  def run
    system "clear"
    puts "Events"
    Event.display_all
    puts ""

    puts "Categories"
    Category.display_all
    puts ""

    input = prompt

    puts "\n\n"
    case input
    when "1"
      add_event
    when "2"
      remove_event
    when "3"
      add_category
    when "4"
      generate
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
      event = Event.create(start_time, end_time, title)
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

    Event.delete(id)
  end

  def prompt
    puts "\n"
    puts "<1> Add event"
    puts "<2> Delete event"
    puts "<3> Add category"
    puts "<4> Generate"
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
    category.save
  end

  def remove_category
    print "ID of category: "
    id = gets.chomp.to_i

    @schedule.remove_category(id)
  end

  def generate
    Generator.generate
  end
end

if $PROGRAM_NAME == __FILE__
  Main.new
end
