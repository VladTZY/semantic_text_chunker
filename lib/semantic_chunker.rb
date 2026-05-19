require_relative "semantic_chunker/version"
require_relative "semantic_chunker/chunker"
require_relative "semantic_chunker/embedders/cohere"
require_relative "semantic_chunker/embedders/openai"
require_relative "semantic_chunker/embedders/open_router"
require_relative "semantic_chunker/embedders/null"

module SemanticChunker
  class EmbedderError < StandardError; end

  def self.chunk(text, **opts)
    Chunker.new(**opts).chunk(text)
  end

  def self.chunk_with_metadata(text, **opts)
    metadata_keys = %i[title author chapter section source]
    chunker_opts  = opts.reject { |k, _| metadata_keys.include?(k) }
    metadata      = opts.select { |k, _| metadata_keys.include?(k) }

    Chunker.new(**chunker_opts).chunk_with_metadata(text, **metadata)
  end
end
