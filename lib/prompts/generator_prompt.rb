require_relative "../generator"
require_relative "prompt"

class GeneratorPrompt < Prompt
  def self.prompt
    display_prompt
    case get_input
    when 1
      generate
    when 2
      delete_generated_events
    when 3
      return false
    else
      puts "Bad input. Try again. Press <enter> to continue."
    end
    true
  end

  def self.display_prompt
    puts "-" * 20
    puts "Generator"
    puts "<1> Generate"
    puts "<2> Delete generated events"
    puts "<3> Exit"
  end

  def self.get_input
    print "<1-3>"
    gets.chomp.to_i
  end

  def self.generate
    Generator.generate
  end

  def self.delete_generated_events
    Generator.clear_generated_events
  end
end
