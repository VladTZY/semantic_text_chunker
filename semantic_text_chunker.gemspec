require_relative "lib/semantic_text_chunker/version"

Gem::Specification.new do |spec|
  spec.name        = "semantic_text_chunker"
  spec.version     = SemanticTextChunker::VERSION
  spec.authors     = ["Vlad Tigănilă"]
  spec.email       = ["tiganilavlad@gmail.com"]

  spec.summary     = "Embedding-aware semantic chunking for Ruby RAG pipelines"
  spec.description = "Detects topic boundaries using embedding similarity to produce semantically coherent chunks from books, articles, and documents. Supports Cohere, OpenAI, and OpenRouter embedders."
  spec.homepage    = "https://github.com/VladTZY/semantic_text_chunker"
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.0.0"
  spec.files = Dir["lib/**/*", "README.md", "LICENSE"]
end
