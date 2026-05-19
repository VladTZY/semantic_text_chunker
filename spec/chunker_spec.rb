require "spec_helper"

RSpec.describe SemanticTextChunker::Chunker do
  subject(:chunker) { described_class.new }

  it "always returns an Array" do
    expect(chunker.chunk("Hello world. This is a test.")).to be_an(Array)
  end

  it "returns empty array for nil input" do
    expect(chunker.chunk(nil)).to eq([])
  end

  it "returns empty array for empty string" do
    expect(chunker.chunk("")).to eq([])
  end

  it "returns empty array for whitespace-only input" do
    expect(chunker.chunk("   ")).to eq([])
  end

  it "chunks text into non-empty strings" do
    text = "The quick brown fox jumped over the lazy dog. " \
           "Machine learning models require large datasets. " \
           "Ruby is a dynamic programming language."
    chunks = chunker.chunk(text)
    expect(chunks).to all(be_a(String))
    expect(chunks).to all(satisfy { |c| !c.strip.empty? })
  end

  describe "#chunk_with_metadata" do
    it "prefixes every chunk with metadata fields" do
      text = "First sentence here. Second sentence here."
      chunks = chunker.chunk_with_metadata(
        text,
        title: "Test Doc",
        author: "Test Author"
      )

      chunks.each do |chunk|
        expect(chunk).to start_with("Title: Test Doc\nAuthor: Test Author\n\n")
      end
    end

    it "works with no metadata" do
      text = "First sentence here. Second sentence here."
      chunks = chunker.chunk_with_metadata(text)
      # No prefix added
      chunks.each do |chunk|
        expect(chunk).not_to start_with("Title:")
      end
    end
  end

  describe "convenience methods" do
    it "SemanticTextChunker.chunk returns chunks" do
      chunks = SemanticTextChunker.chunk("Hello world. This is a test.")
      expect(chunks).to be_an(Array)
    end

    it "SemanticTextChunker.chunk_with_metadata returns prefixed chunks" do
      chunks = SemanticTextChunker.chunk_with_metadata(
        "Hello world. This is a test.",
        title: "My Doc"
      )
      expect(chunks).to be_an(Array)
      expect(chunks.first).to include("Title: My Doc")
    end
  end
end
