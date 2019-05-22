require_relative "../category"

class CategoryPrompt < Prompt
  def self.display_prompt
    super("Category")
  end

  def self.add
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

  def self.delete
    print "ID of category: "
    id = gets.chomp.to_i

    Category.delete(id)
  end

  def self.edit; end
end
