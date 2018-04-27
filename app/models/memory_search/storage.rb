module MemorySearch
  class Storage
    attr_reader :indices

    def initialize
      @indices = {}
    end

    def find_index(name:)
      @indices[name]
    end

    def find_or_create_index(name:)
      @indices[name] ||= Index.new(name: name)
    end
  end
end
