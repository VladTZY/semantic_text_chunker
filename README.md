# SemanticTextChunker

Embedding-aware semantic chunking for Ruby RAG pipelines. Splits text into coherent chunks by detecting topic boundaries using embedding similarity, rather than blindly splitting on character count.

## Installation

Add to your Gemfile:

```ruby
gem "semantic_text_chunker"
```

Then run:

```sh
bundle install
```

Or install directly:

```sh
gem install semantic_text_chunker
```

## Quick Start

```ruby
require "semantic_text_chunker"

text = "Your long document text here..."

# Using OpenAI embeddings
chunks = SemanticTextChunker.chunk(text,
  embedder: SemanticTextChunker::Embedders::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])
)

chunks.each { |chunk| puts chunk, "---" }
```

## Embedders

### OpenAI

```ruby
embedder = SemanticTextChunker::Embedders::OpenAI.new(
  api_key: ENV["OPENAI_API_KEY"],
  model: "text-embedding-3-small"  # default
)
```

### Cohere

```ruby
embedder = SemanticTextChunker::Embedders::Cohere.new(
  api_key: ENV["COHERE_API_KEY"],
  model: "embed-english-v3.0"  # default
)
```

### OpenRouter

```ruby
embedder = SemanticTextChunker::Embedders::OpenRouter.new(
  api_key: ENV["OPENROUTER_API_KEY"],
  model: "openai/text-embedding-3-small"  # default
)
```

### Null (no API required)

A hash-based embedder useful for testing and development. No external API calls needed.

```ruby
embedder = SemanticTextChunker::Embedders::Null.new
```

## Options

| Option              | Default | Description                                         |
|---------------------|---------|-----------------------------------------------------|
| `embedder`          | `Null`  | Embedder instance to use for generating embeddings   |
| `threshold`         | `0.75`  | Cosine similarity threshold for detecting boundaries |
| `max_tokens`        | `512`   | Maximum tokens per chunk (estimated at ~4 chars/token) |
| `overlap_sentences` | `2`     | Number of sentences to overlap between chunks        |

```ruby
chunks = SemanticTextChunker.chunk(text,
  embedder: embedder,
  threshold: 0.8,
  max_tokens: 1024,
  overlap_sentences: 3
)
```

## Metadata

Prepend metadata to each chunk for better retrieval context:

```ruby
chunks = SemanticTextChunker.chunk_with_metadata(text,
  embedder: embedder,
  title: "The Great Gatsby",
  author: "F. Scott Fitzgerald",
  chapter: "Chapter 1",
  section: "Opening",
  source: "gutenberg.org"
)
```

Each chunk will be prefixed with:

```
Title: The Great Gatsby
Author: F. Scott Fitzgerald
Chapter: Chapter 1
Section: Opening
Source: gutenberg.org

<chunk text>
```

## Custom Embedders

Create your own embedder by subclassing `SemanticTextChunker::Embedders::Base`:

```ruby
class MyEmbedder < SemanticTextChunker::Embedders::Base
  def embed(texts)
    # texts is an array of strings
    # Return an array of embedding vectors (arrays of floats)
    texts.map { |t| your_embedding_logic(t) }
  end
end
```

The base class provides a `cosine_similarity` method used for boundary detection.

## How It Works

1. **Sentence splitting** - Text is split into sentences using punctuation-aware rules that handle abbreviations (Mr., Dr., U.S., etc.)
2. **Embedding** - Each sentence is embedded using the configured embedder
3. **Boundary detection** - Consecutive sentences are grouped. A new chunk boundary is created when the cosine similarity between the accumulated chunk embedding and the next sentence drops below the threshold, or when the token limit is exceeded
4. **Chunk building** - Sentences are assembled into chunks with configurable overlap for context continuity

## License

MIT
