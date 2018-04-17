module MemorySearch
  module API
    def self.included(base)
      base.send :include,
                MemorySearch::API::Actions,
                MemorySearch::API::Indices
                # MemorySearch::API::Common,
                # MemorySearch::API::Cluster,
                # MemorySearch::API::Nodes,
                # MemorySearch::API::Ingest,
                # MemorySearch::API::Snapshot,
                # MemorySearch::API::Tasks,
                # MemorySearch::API::Cat
    end
  end
end
