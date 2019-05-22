require_relative "../event"
require_relative "prompt"

class EventPrompt < Prompt
  def self.display_prompt
    super("Event")
  end

  def self.add
    puts "Example: 1.30 is equivalent to 1:30AM / 23:40 => 11:40PM"
    print "Start time: "
    start_time = gets.chomp.to_f
    print "End time: "
    end_time = gets.chomp.to_f
    print "Title: "
    title = gets.chomp

    Event.create(start_time, end_time, title)
    puts "Event successfully added!"
    puts "Event couldn't be added"
  rescue ArgumentError => e
    puts e
    retry
  end

  def self.delete
    print "ID of event: "
    id = gets.chomp.to_i

    Event.delete(id)
  end

  def self.edit; end
end
