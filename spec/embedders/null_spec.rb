require "spec_helper"

RSpec.describe SemanticTextChunker::Embedders::Null do
  subject(:embedder) { described_class.new }

  it "returns 512-dimensional vectors" do
    vectors = embedder.embed(["Hello world"])
    expect(vectors.first.size).to eq(512)
  end

  it "returns normalized vectors" do
    vectors = embedder.embed(["Hello world"])
    magnitude = Math.sqrt(vectors.first.sum { |x| x**2 })
    expect(magnitude).to be_within(0.001).of(1.0)
  end

  it "returns cosine similarity of 1.0 for identical texts" do
    vectors = embedder.embed(["Hello world", "Hello world"])
    similarity = embedder.cosine_similarity(vectors[0], vectors[1])
    expect(similarity).to be_within(0.001).of(1.0)
  end

  it "returns lower similarity for different texts" do
    vectors = embedder.embed(["The cat sat on the mat", "Quantum physics is complex"])
    similarity = embedder.cosine_similarity(vectors[0], vectors[1])
    expect(similarity).to be < 1.0
  end

  it "handles multiple texts in a single call" do
    vectors = embedder.embed(["First", "Second", "Third"])
    expect(vectors.size).to eq(3)
    vectors.each { |v| expect(v.size).to eq(512) }
  end
end
