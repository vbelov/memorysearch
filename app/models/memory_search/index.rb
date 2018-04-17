module MemorySearch
  class Index
    include Virtus::Model

    attribute :name, String
    attribute :documents, Array[Document]
  end
end
