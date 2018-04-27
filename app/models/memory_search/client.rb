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

    def check_ignored_params(ignored_params, method_arguments)
      used_params = ignored_params.select {|param| method_arguments.key?(param)}
      if used_params.any?
        Rails.logger.error(
            "Following method params are not supported by MemorySearch and will be ignored:"\
            " #{used_params.map(&:to_s).join(', ')}"
        )
      end
    end
  end
end
