require_relative "splitters/sentence_splitter"
require_relative "embedders/base"
require_relative "embedders/null"
require_relative "boundary_detector"
require_relative "chunk_builder"
require_relative "metadata"

module SemanticTextChunker
  class Chunker
    def initialize(
      embedder: Embedders::Null.new,
      threshold: 0.75,
      max_tokens: 512,
      overlap_sentences: 2
    )
      @embedder          = embedder
      @threshold         = threshold
      @max_tokens        = max_tokens
      @overlap_sentences = overlap_sentences
      @splitter          = Splitters::SentenceSplitter.new
    end

    def chunk(text)
      return [] if text.nil? || text.strip.empty?

      sentences  = @splitter.split(text)
      embeddings = @embedder.embed(sentences)

      boundaries = BoundaryDetector.new(
        sentences:  sentences,
        embeddings: embeddings,
        threshold:  @threshold,
        max_tokens: @max_tokens,
        embedder:   @embedder
      ).boundaries

      ChunkBuilder.new(
        sentences:         sentences,
        boundaries:        boundaries,
        overlap_sentences: @overlap_sentences
      ).build
    end

    def chunk_with_metadata(text, **metadata)
      prefix = Metadata.prefix(**metadata)
      chunk(text).map { |c| prefix + c }
    end
  end
end
