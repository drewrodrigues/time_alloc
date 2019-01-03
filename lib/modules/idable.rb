# TODO create #create method
# Upon inclusion, IDable will allow basic class instance management as well
# as assigning IDs for each new instance that is created.
module IDable
  # include class methods & set class instance variables
  def self.included(klass)
    klass.extend(ClassMethods)
    klass.instance_variable_set(:@instances, [])
    klass.instance_variable_set(:@next_id, 0)
  end

  attr_accessor :id

  # add self to class instances
  def initialize
    self.class.add(self)
  end

  module ClassMethods
    # adds the instance to class instances
    # @param instance of class
    def add(instance)
      instance.id = assign_next_id
      all << instance
    end

    # @return true or nil
    def delete(id)
      all.reject! {|i| i.id == id}
    end

    # @param [Integer] id of instance
    # @return first instance found with id
    def find(id)
      all.find {|i| i.id == id}
    end

    # @return [Integer] instance count
    def count
      all.count
    end

    # @return all instances of class
    def all
      @instances
    end

    # increments next_id and returns the previous available id
    # @return [Integer] next available id
    def assign_next_id
      @next_id += 1
      @next_id - 1
    end

    # TODO make a better solution, since this is only for testing
    def reset_instance_cache
      @instances = []
      @next_id = 0
    end
  end
end
