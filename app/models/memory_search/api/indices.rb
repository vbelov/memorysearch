Dir[ File.expand_path('../indices/actions/*.rb', __FILE__) ].each   { |f| require_dependency f }

module MemorySearch
  module API
    module Indices
      module Actions; end

      # Client for the "indices" namespace (includes the {Indices::Actions} methods)
      #
      class IndicesClient
        include ::Elasticsearch::API::Common::Client,
                ::Elasticsearch::API::Common::Client::Base,
                ::Elasticsearch::API::Indices::Actions
        include ::MemorySearch::API::Indices::Actions

        delegate :storage, :check_ignored_params, to: :client
      end

      # Proxy method for {IndicesClient}, available in the receiving object
      #
      def indices
        @indices ||= IndicesClient.new(self)
      end

    end
  end
end
