require_relative "lib/category"
require_relative "lib/event"
require_relative "lib/generator"
require_relative "lib/schedule"

class Main
  attr_reader :event_prompt, :category_prompt, :generator_prompt

  def initialize
    @schedule = Schedule.new
    @event_prompt = EventPrompt.new(@schedule)
    @category_prompt = CategoryPrompt.new(@schedule)
    @generator_prompt = GeneratorPrompt.new(@schedule)

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

    display_prompt
    select_model
  end

  private

  def model_prompt 
    puts "<1> Events"
    puts "<2> Categories"
    puts "<3> Generator"
  end

  def select_model
    model_prompt
    input = gets.chomp.to_i
    case input
    when 1
      EventPrompt.prompt
    when 2
      CategoryPrompt.prompt
    when 3
      GeneratorPrompt.prompt
    else
      puts "Bad input. Try again."
      gets
    end
  end
end

if $PROGRAM_NAME == __FILE__
  Main.new
end
