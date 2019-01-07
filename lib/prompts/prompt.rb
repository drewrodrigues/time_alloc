# display_prompt is expected to be implement on each class
class Prompt
  self.abstract_class = true

  attr_reader :schedule

  def initialize(schedule)
    @schedule = schedule
  end

  # @return [Boolean] true unless 4
  def prompt
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

  private

  def display_prompt(title = nil)
    puts "<1> Add"
    puts "<2> Delete"
    puts "<3> Edit" # TODO: implement on IDable?
    puts "<4> Exit"
  end

  def get_input
    print "<1-4>: "
    gets
  end
end
