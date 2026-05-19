require "net/http"
require "json"
require "uri"

module SemanticTextChunker
  module Embedders
    class Cohere < Base
      BATCH_SIZE = 96
      ENDPOINT   = "https://api.cohere.com/v1/embed"

      def initialize(api_key:, model: "embed-english-v3.0")
        @api_key = api_key
        @model   = model
      end

      def embed(texts)
        texts.each_slice(BATCH_SIZE).flat_map do |batch|
          response = post(batch)
          response["embeddings"] || raise(EmbedderError, "No embeddings in response: #{response}")
        end
      end

      private

      def post(texts)
        uri  = URI(ENDPOINT)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        req = Net::HTTP::Post.new(uri)
        req["Authorization"]  = "Bearer #{@api_key}"
        req["Content-Type"]   = "application/json"
        req.body = { texts: texts, model: @model, input_type: "search_document" }.to_json

        res = http.request(req)
        raise EmbedderError, "Cohere #{res.code}: #{res.body}" unless res.is_a?(Net::HTTPSuccess)
        JSON.parse(res.body)
      end
    end
  end
end
