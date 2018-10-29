# set a ID for a group
# which are sequential
# all starting from 0
# assumes class has a id property

module IDable
  attr_reader :id

  @@instances = []
  @@next_id = @@instances.last ? @@instances.last.id + 1 : 0

  def initialize
    super
    assign_id
    @@instances << self
  end

  def assign_id 
    @id = IDable.assign_next_id
  end

  def all # TODO: make class methods
    @@instances
  end

  def count # TODO: make class methods
    @@instances.count
  end

  private

  def self.assign_next_id # TODO: make class method upon including class
    assigned_id = @@next_id
    @@next_id += 1
    assigned_id
  end 
end
