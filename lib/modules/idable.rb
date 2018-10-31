# set a ID for a group
# which are sequential
# all starting from 0
# assumes class has a id property

# TODO: write documentation
# TODO: cleanup class methods and instance methods with klass include?
module IDable
  attr_reader :id

  @@instances = []
  @@next_id = @@instances.last ? @@instances.last.id + 1 : 0

  # assigns next ID to class and adds instance to @@instances collection
  def initialize
    # TODO: review how module intiailize method gets mixed in,
    # what order are they called. Stack overflow said to call it from the class to get it called
    assign_id
    @@instances << self
  end


  def assign_id 
    @id = IDable.assign_next_id
  end

  # FIXME: make a class method
  # FIXME: right now it adds all classes to the same instance
  # returns all instances of the class   
  def self.all
    @@instances
  end

  # instances count
  def count
    @@instances.count
  end

  private

  def self.assign_next_id # TODO: make class method upon including class
    assigned_id = @@next_id
    @@next_id += 1
    assigned_id
  end 
end
