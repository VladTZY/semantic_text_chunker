module SemanticChunker
  module Embedders
    class Base
      def embed(texts)
        raise NotImplementedError, "#{self.class} must implement #embed"
      end

      def cosine_similarity(a, b)
        dot   = a.zip(b).sum { |x, y| x * y }
        mag_a = Math.sqrt(a.sum { |x| x**2 })
        mag_b = Math.sqrt(b.sum { |x| x**2 })
        return 0.0 if mag_a.zero? || mag_b.zero?
        dot / (mag_a * mag_b)
      end
    end
  end
end
