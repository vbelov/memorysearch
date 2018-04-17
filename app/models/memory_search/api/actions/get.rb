module MemorySearch
  module API
    module Actions

      # Return a specified document.
      #
      # The response contains full document, as stored in Elasticsearch, incl. `_source`, `_version`, etc.
      #
      # @example Get a document
      #
      #     client.get index: 'myindex', type: 'mytype', id: '1'
      #
      # @option arguments [String] :id The document ID (*Required*)
      # @option arguments [Number,List] :ignore The list of HTTP errors to ignore; only `404` supported at the moment
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document; use `_all` to fetch the first document
      #                                  matching the ID across all types) (*Required*)
      # @option arguments [List] :fields A comma-separated list of fields to return in the response
      # @option arguments [String] :parent The ID of the parent document
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [Boolean] :realtime Specify whether to perform the operation in realtime or search mode
      # @option arguments [Boolean] :refresh Refresh the shard containing the document before performing the operation
      # @option arguments [String] :routing Specific routing value
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external, external_gte, force)
      # @option arguments [String] :_source Specify whether the _source field should be returned,
      #                                     or a list of fields to return
      # @option arguments [String] :_source_exclude A list of fields to exclude from the returned _source field
      # @option arguments [String] :_source_include A list of fields to extract and return from the _source field
      # @option arguments [Boolean] :_source_transform Retransform the source before returning it
      # @option arguments [List] :stored_fields A comma-separated list of stored fields to return in the response
      #
      # @see http://elasticsearch.org/guide/reference/api/get/
      #
      def get(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'id' missing"    unless arguments[:id]
        arguments[:type] ||= UNDERSCORE_ALL # TODO implement support

        # TODO warn of not implemented params
        valid_params = [
            :fields,
            :parent,
            :preference,
            :realtime,
            :refresh,
            :routing,
            :version,
            :version_type,
            :_source,
            :_source_include,
            :_source_exclude,
            :_source_transform,
            :stored_fields ]

        # method = HTTP_GET
        # path   = Utils.__pathify Utils.__escape(arguments[:index]),
        #                          Utils.__escape(arguments[:type]),
        #                          Utils.__escape(arguments[:id])

        # params = Utils.__validate_and_extract_params arguments, valid_params
        # body   = nil

        # params[:fields] = Utils.__listify(params[:fields]) if params[:fields]

        # TODO support for ignore
        # if Array(arguments[:ignore]).include?(404)
        #   Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
        # else
        #   perform_request(method, path, params, body).body
        # end


        index_name = arguments[:index]
        type_name = arguments[:type]
        document_id = arguments[:id]

        index = storage.indices[index_name]

        document = nil
        if index
          document = index.documents.find do |doc|
            doc.type == type_name && doc.id == document_id
          end
        end

        if document
          {
              _index: index_name,
              _type: type_name,
              _id: document_id,
              _version: document.version,
              found: true,
              _source: document.source,
          }.deep_stringify_keys
        else
          {
              found: false,
          }.deep_stringify_keys
        end
      end
    end
  end
end
