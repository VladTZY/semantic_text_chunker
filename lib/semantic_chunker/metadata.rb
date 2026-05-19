module SemanticChunker
  module Metadata
    KNOWN_KEYS = %i[title author chapter section source].freeze

    def self.prefix(**kwargs)
      lines = []

      KNOWN_KEYS.each do |key|
        val = kwargs[key]
        lines << "#{key.to_s.capitalize}: #{val}" if val && !val.to_s.empty?
      end

      # Any extra keys appended at end, titlecased
      (kwargs.keys - KNOWN_KEYS).each do |key|
        val = kwargs[key]
        lines << "#{key.to_s.split('_').map(&:capitalize).join(' ')}: #{val}" if val
      end

      lines.empty? ? "" : lines.join("\n") + "\n\n"
    end
  end
end
