module MemorySearch
  class Search
    class DocumentMask
      attr_reader :doc

      def initialize(doc)
        @doc = doc
      end

      def matches?(query)
        query(query)
      end

      private

      def query(hash)
        if hash.keys.one?
          key, val = hash.first
          case key
          when :term
            term(val)
          when :bool
            bool(val)
          else
            raise NotImplementedError
          end
        elsif hash.keys.none?
          true
        else
          raise NotImplementedError
        end
      end

      def term(hash)
        key, val = hash.to_a.first
        # TODO check that only one pair
        # TODO case when val is a hash
        # TODO case when key is path
        doc.source[key.to_s] == val
      end

      def bool(hash)
        res = true
        res &&= must(hash[:must]) if hash[:must]
        res &&= filter(hash[:filter]) if hash[:filter]
        res &&= should(hash[:should]) if hash[:should]
        res &&= must_not(hash[:must_not]) if hash[:must_not]
        res
      end

      def must(arr)
        arr = Array.wrap(arr)
        arr.all? {|q| query(q)}
      end

      def filter(arr)
        raise NotImplementedError
      end

      def should(arr)
        arr = Array.wrap(arr)
        arr.any? {|q| query(q)}
      end

      def must_not(arr)
        raise NotImplementedError
      end
    end
  end
end
