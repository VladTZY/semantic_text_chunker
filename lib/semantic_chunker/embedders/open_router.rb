require "net/http"
require "json"
require "uri"

module SemanticChunker
  module Embedders
    class OpenRouter < Base
      BATCH_SIZE = 100
      ENDPOINT   = "https://openrouter.ai/api/v1/embeddings"

      def initialize(api_key:, model: "openai/text-embedding-3-small", site_url: nil, site_name: nil)
        @api_key   = api_key
        @model     = model
        @site_url  = site_url  || "https://github.com/VladTZY/semantic_chunker"
        @site_name = site_name || "semantic_chunker"
      end

      def embed(texts)
        texts.each_slice(BATCH_SIZE).flat_map do |batch|
          response = post(batch)
          response["data"].map { |d| d["embedding"] }
        end
      end

      private

      def post(texts)
        uri  = URI(ENDPOINT)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        req = Net::HTTP::Post.new(uri)
        req["Authorization"] = "Bearer #{@api_key}"
        req["Content-Type"]  = "application/json"
        req["HTTP-Referer"]  = @site_url   # Required by OpenRouter
        req["X-Title"]       = @site_name
        req.body = { input: texts, model: @model }.to_json

        res = http.request(req)
        raise EmbedderError, "OpenRouter #{res.code}: #{res.body}" unless res.is_a?(Net::HTTPSuccess)
        JSON.parse(res.body)
      end
    end
  end
end
