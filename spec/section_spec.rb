require_relative 'spec_helper'

describe 'Whatsa::Section' do

  # Does this get cached between tests? Or am I sending rapid requests?
  let(:works) do
    pars = [
      "Some pop-up books receive attention as literary works for the degree of artistry or sophistication which they entail. One example is Star Wars: A Pop-Up Guide to the Galaxy, by Matthew Reinhart. This book received literary attention for its elaborate pop-ups, and the skill of its imagery, with The New York Times saying that \"calling this sophisticated piece of engineering a 'pop-up book' is like calling the Great Wall of China a partition\".[6]",
      "The 1967 Random House publication Andy Warhol's Index, was produced by Andy Warhol, Chris Cerf and Alan Rinzler, and included photos of celebrities together with pop-up versions of Warholesque images such as a cardboard can of tomato paste,[2] as well as a plastic tear-out recording, an inflatable silver balloon, and other novelties."
    ]
    Whatsa::Section.new('Notable works', pars)
  end

  it "has a title and paragraphs" do
    expect(works.title).to eq('Notable works')
    expect(works.paragraphs.size).to be > 1
  end

  describe '#summary' do
    it "returns the first paragraph of the section" do

      first = "Some pop-up books receive attention as literary works for the degree of artistry or sophistication which they entail. One example is Star Wars: A Pop-Up Guide to the Galaxy, by Matthew Reinhart. This book received literary attention for its elaborate pop-ups, and the skill of its imagery, with The New York Times saying that \"calling this sophisticated piece of engineering a 'pop-up book' is like calling the Great Wall of China a partition\".[6]"

      expect(works.summary).to eq(first)

    end
  end

  describe '#full_text' do
    it "returns all of the paragraphs in the section, separated by newlines" do

      text = "Some pop-up books receive attention as literary works for the degree of artistry or sophistication which they entail. One example is Star Wars: A Pop-Up Guide to the Galaxy, by Matthew Reinhart. This book received literary attention for its elaborate pop-ups, and the skill of its imagery, with The New York Times saying that \"calling this sophisticated piece of engineering a 'pop-up book' is like calling the Great Wall of China a partition\".[6]\n\nThe 1967 Random House publication Andy Warhol's Index, was produced by Andy Warhol, Chris Cerf and Alan Rinzler, and included photos of celebrities together with pop-up versions of Warholesque images such as a cardboard can of tomato paste,[2] as well as a plastic tear-out recording, an inflatable silver balloon, and other novelties."

      expect(works.full_text).to eq(text)

    end
  end

end
