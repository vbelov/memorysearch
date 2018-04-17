module MemorySearch
  class Client
    include Elasticsearch::API
    include MemorySearch::API

    attr_reader :storage

    def initialize(*args)
      @storage = Storage.new
    end

    def perform_request(method, path, params={}, body=nil)
      raise NotImplementedError,
            'This client will not dispatch requests to Elasticsearch.'\
            ' You need to implement corresponding MemorySearch::API module.'\
            " Attempted to make #{method} request to #{path}."
    end

    class << self
      def use
        Thread.current[:chewy_client] = MemorySearch::Client.new
      end
    end
  end
end
