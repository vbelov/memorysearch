module MemorySearch
  class Storage
    attr_reader :indices

    def initialize
      @indices = {}
    end

    def find_indices(name_pattern)
      pattern = name_pattern.gsub('*', '.*')
      pattern = "^#{pattern}$"
      pattern = Regexp.new(pattern)

      @indices.select {|name, _| name =~ pattern}.map(&:last)
    end

    def find_index(name:)
      @indices[name]
    end

    def find_or_create_index(name:)
      @indices[name] ||= Index.new(name: name)
    end
  end
end
