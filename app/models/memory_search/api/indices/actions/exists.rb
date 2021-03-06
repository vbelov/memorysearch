module Elasticsearch
  module API
    module Indices
      module Actions

        # Return true if the index (or all indices in a list) exists, false otherwise.
        #
        # @example Check whether index named _myindex_ exists
        #
        #     client.indices.exists? index: 'myindex'
        #
        # @option arguments [List] :index A comma-separated list of indices to check (*Required*)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into
        #                                               no concrete indices. (This includes `_all` string or when no
        #                                               indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that
        #                                              are open, closed or both. (options: open, closed)
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore
        #                                            `missing` ones (options: none, missing) @until 1.0
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
        #                                                 unavailable (missing, closed, etc)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        #
        # @return [true,false]
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-indices-exists/
        #
        def exists(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          ignored_params = [
            :ignore_indices,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :local
          ]
          check_ignored_params(ignored_params, arguments)

          index_names = Array.wrap(arguments[:index])
          index_names.all? do |name_pattern|
            storage.find_indices(name_pattern).any?
          end
        end

        alias_method :exists?, :exists
      end
    end
  end
end
