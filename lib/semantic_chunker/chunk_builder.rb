module SemanticChunker
  class ChunkBuilder
    def initialize(sentences:, boundaries:, overlap_sentences:)
      @sentences         = sentences
      @boundaries        = boundaries
      @overlap_sentences = overlap_sentences
    end

    def build
      return [@sentences.join(" ")] if @boundaries.empty?

      chunks = []
      prev_end = -1

      split_points = @boundaries + [@sentences.size - 1]

      split_points.each_with_index do |boundary, idx|
        start = if idx == 0
          0
        else
          # Overlap: go back N sentences from previous boundary
          [prev_end - @overlap_sentences + 1, 0].max
        end

        chunk = @sentences[start..boundary].join(" ").strip
        chunks << chunk unless chunk.empty?
        prev_end = boundary
      end

      chunks
    end
  end
end
