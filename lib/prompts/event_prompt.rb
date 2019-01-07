require_relative '../event'

class EventPrompt < Prompt
  private

  def display_prompt
    super("Event")
  end
  
  def add
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

 def delete 
    print "ID of event: "
    id = gets.chomp.to_i

    Event.delete(id)
  end
end

