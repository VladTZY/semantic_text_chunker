module SemanticTextChunker
  module Embedders
    class Null < Base
      def embed(texts)
        texts.map do |text|
          words = text.downcase.split.uniq
          vec   = Array.new(512, 0.0)
          words.each { |w| vec[w.hash.abs % 512] += 1.0 }
          norm = Math.sqrt(vec.sum { |x| x**2 })
          norm > 0 ? vec.map { |x| x / norm } : vec
        end
      end
    end
  end
end
