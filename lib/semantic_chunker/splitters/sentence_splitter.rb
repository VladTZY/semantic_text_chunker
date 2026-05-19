module SemanticChunker
  module Splitters
    class SentenceSplitter
      ABBREVS = %w[Mr Mrs Dr Prof Sr Jr vs etc e.g i.e U.S U.K U.S.A Fig Vol No].freeze
      ABBREV_PATTERN = /\b(#{ABBREVS.map { |a| Regexp.escape(a) }.join("|")})\.\s/

      def split(text)
        # Temporarily replace abbreviation periods
        protected = text.gsub(ABBREV_PATTERN) { "#{$1}__ABBREV__ " }

        sentences = protected
          .split(/(?<=[.?!])\s+(?=[A-Z])/)
          .map { |s| s.gsub("__ABBREV__", ".").strip }
          .reject(&:empty?)

        sentences
      end
    end
  end
end
