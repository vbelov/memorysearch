Dir[ File.expand_path('../actions/*.rb', __FILE__) ].each   { |f| require_dependency f }

module MemorySearch
  module API
    module Actions; end
  end
end
