module MemorySearch
  class Document
    include Virtus::Model

    attribute :index, Index
    attribute :type, String
    attribute :id, String
    attribute :version, Integer
    attribute :source, Hash
  end
end
