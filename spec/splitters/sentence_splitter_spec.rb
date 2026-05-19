require "spec_helper"

RSpec.describe SemanticTextChunker::Splitters::SentenceSplitter do
  subject(:splitter) { described_class.new }

  it "splits on sentence-ending punctuation followed by uppercase" do
    text = "Hello world. This is a test. Another sentence here."
    sentences = splitter.split(text)
    expect(sentences).to eq([
      "Hello world.",
      "This is a test.",
      "Another sentence here."
    ])
  end

  it "does not split on Dr." do
    text = "Dr. Smith went to the store. He bought milk."
    sentences = splitter.split(text)
    expect(sentences).to eq([
      "Dr. Smith went to the store.",
      "He bought milk."
    ])
  end

  it "does not split on Mr." do
    text = "Mr. Jones arrived early. The meeting started."
    sentences = splitter.split(text)
    expect(sentences).to eq([
      "Mr. Jones arrived early.",
      "The meeting started."
    ])
  end

  it "does not split on U.S.A." do
    text = "She lives in the U.S.A. The weather is nice."
    sentences = splitter.split(text)
    expect(sentences).to eq([
      "She lives in the U.S.A. The weather is nice."
    ])
  end

  it "does not split on e.g." do
    text = "Use a language, e.g. Ruby. It works well."
    sentences = splitter.split(text)
    expect(sentences).to eq([
      "Use a language, e.g. Ruby.",
      "It works well."
    ])
  end

  it "splits on question marks" do
    text = "What is this? This is a test."
    sentences = splitter.split(text)
    expect(sentences).to eq([
      "What is this?",
      "This is a test."
    ])
  end

  it "splits on exclamation marks" do
    text = "Wow! That is great."
    sentences = splitter.split(text)
    expect(sentences).to eq([
      "Wow!",
      "That is great."
    ])
  end

  it "returns empty array for empty string" do
    expect(splitter.split("")).to eq([])
  end
end
