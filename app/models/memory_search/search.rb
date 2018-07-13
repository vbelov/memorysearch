module MemorySearch
  class Search
    attr_reader :index, :body

    def initialize(index, body)
      @index = index
      @body = body.deep_symbolize_keys
    end

    def self.aaa(indices, body)
      documents =
        indices.flat_map do |index|
          new(index, body).documents
        end

      hits = documents.map do |document|
        {
            _index: document.index.name,
            _type: document.type,
            _id: document.id,
            _score: 1.0,
            _source: document.source
        }
      end

      {
          took: 1,
          timed_out: false,
          _shards: {
              total: 5,
              successful: 5,
              skipped: 0,
              failed: 0
          },
          hits: {
              total: hits.count,
              max_score: 1.0,
              hits: hits
          }
      }
    end

    def documents
      index.documents.select do |doc|
        query = body[:query]
        Search::DocumentMask.new(doc).matches?(query)
      end
    end
  end
end
