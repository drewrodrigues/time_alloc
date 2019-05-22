require_relative "lib/schedule"
require_relative "lib/prompts/event_prompt"
require_relative "lib/prompts/generator_prompt"
require_relative "lib/prompts/category_prompt"

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
