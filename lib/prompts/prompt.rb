# display_prompt is expected to be implement on each class
class Prompt
  attr_reader :schedule

  # @return [Boolean] true unless 4
  def self.prompt
    display_prompt
    case get_input
    when 1
      add
    when 2
      delete
    when 3
      edit
    when 4
      return false
    else
      puts "Bad input. Try again. Press <enter> to continue."
      gets
    end
    true
  end

  def self.display_prompt(title = nil)
    puts "-" * 20
    puts title
    puts "<1> Add"
    puts "<2> Delete"
    puts "<3> Edit" # TODO: implement on IDable?
    puts "<4> Exit"
  end

  def self.get_input
    print "<1-4>: "
    gets.chomp.to_i
  end
end
