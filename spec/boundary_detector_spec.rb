require "spec_helper"

RSpec.describe SemanticTextChunker::BoundaryDetector do
  let(:embedder) { SemanticTextChunker::Embedders::Null.new }

  it "returns empty boundaries for a single sentence" do
    sentences  = ["Just one sentence."]
    embeddings = embedder.embed(sentences)

    detector = described_class.new(
      sentences: sentences, embeddings: embeddings,
      threshold: 0.75, max_tokens: 512, embedder: embedder
    )

    expect(detector.boundaries).to eq([])
  end

  it "forces boundary when token limit is exceeded" do
    # Create sentences that together exceed a small token limit
    sentences = [
      "A" * 100,
      "B" * 100,
      "C" * 100
    ]
    embeddings = embedder.embed(sentences)

    detector = described_class.new(
      sentences: sentences, embeddings: embeddings,
      threshold: 0.0, max_tokens: 60, embedder: embedder
    )

    boundaries = detector.boundaries
    expect(boundaries).not_to be_empty
  end

  it "detects boundary when similarity drops below threshold" do
    # Use very different sentences to trigger low similarity
    sentences = [
      "The cat sat on the mat.",
      "The cat slept on the mat.",
      "Quantum entanglement enables instantaneous state correlation across distances."
    ]
    embeddings = embedder.embed(sentences)

    detector = described_class.new(
      sentences: sentences, embeddings: embeddings,
      threshold: 0.95, max_tokens: 10_000, embedder: embedder
    )

    boundaries = detector.boundaries
    expect(boundaries).not_to be_empty
  end

  it "returns no boundaries for very similar sentences with low threshold" do
    sentences = [
      "The cat sat on the mat.",
      "The cat slept on the mat.",
      "The cat rested on the mat."
    ]
    embeddings = embedder.embed(sentences)

    detector = described_class.new(
      sentences: sentences, embeddings: embeddings,
      threshold: 0.1, max_tokens: 10_000, embedder: embedder
    )

    expect(detector.boundaries).to eq([])
  end
end
