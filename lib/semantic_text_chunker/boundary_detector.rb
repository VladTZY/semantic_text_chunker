module SemanticTextChunker
  class BoundaryDetector
    def initialize(sentences:, embeddings:, threshold:, max_tokens:, embedder:)
      @sentences  = sentences
      @embeddings = embeddings
      @threshold  = threshold
      @max_tokens = max_tokens
      @embedder   = embedder
    end

    # Returns array of sentence indices where chunks end
    def boundaries
      return [] if @sentences.size <= 1

      boundaries    = []
      chunk_start   = 0
      current_text  = ""

      @sentences.each_with_index do |sentence, i|
        next if i == 0
        current_text = @sentences[chunk_start..i - 1].join(" ")
        next_text    = current_text + " " + sentence

        # Force boundary if adding this sentence exceeds token limit
        if tokens(next_text) > @max_tokens
          boundaries << i - 1
          chunk_start  = i
          current_text = ""
          next
        end

        # Compute similarity between accumulated chunk and next sentence
        chunk_embedding    = mean_embedding(@embeddings[chunk_start..i - 1])
        sentence_embedding = @embeddings[i]
        similarity         = @embedder.cosine_similarity(chunk_embedding, sentence_embedding)

        if similarity < @threshold
          boundaries << i - 1
          chunk_start = i
        end
      end

      boundaries
    end

    private

    def mean_embedding(embeddings)
      return embeddings.first if embeddings.size == 1
      dim = embeddings.first.size
      sum = Array.new(dim, 0.0)
      embeddings.each { |e| e.each_with_index { |v, i| sum[i] += v } }
      sum.map { |v| v / embeddings.size }
    end

    def tokens(text)
      (text.length / 4.0).ceil
    end
  end
end
