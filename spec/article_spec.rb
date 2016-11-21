require_relative 'spec_helper'

describe 'Whatsa::Article' do

  # The article described here does not actually have paragraphs in its sections.
  # That is not a bug--it's just that every section is composed of bullet items
  # (every section's text is a <ul> element). I've chosen not to include list
  # items as "paragraphs".

  let(:test_sec) do
    pars = ["hello", "I am a paragraph.", "Welcome to the paragraph zone."]
    Whatsa::Section.new('Test', pars)
  end
  # Does this get cached between tests? Or am I sending rapid requests?
  let(:expurg) do
    doc = Nokogiri::HTML(open('https://en.wikipedia.org/wiki/Expurgation'))
    art = Whatsa::Article.new(doc)
    art.sections << test_sec
    art
  end

  it "has a title and contents" do
    expect(expurg.title).to eq('Expurgation')
    expect(expurg.contents.size).to be > 1
  end

  describe '#intro_pars' do
    it "returns the introductory paragraphs as an array" do

      intros = [
        "Expurgation is a form of censorship which involves purging anything deemed noxious or offensive, usually from an artistic work.",
        "Bowdlerization is a pejorative term for the practice, particularly the expurgation of lewd material from books. The term derives from Thomas Bowdler's 1818 edition of William Shakespeare's plays, which he reworked in order to make them more suitable, in his opinion, for women and children.[1] He similarly edited Edward Gibbon's Decline and Fall of the Roman Empire.",
        "A fig-leaf edition is such a bowdlerized text, deriving from the practice of covering the genitals of nudes in classical and Renaissance statues and paintings with fig leaves."
      ]

      expect(expurg.intro_pars).to match_array(intros)
    end
  end

  describe '#summary' do
    it "returns the first paragraph in the article" do

      intro = "Expurgation is a form of censorship which involves purging anything deemed noxious or offensive, usually from an artistic work."

      expect(expurg.summary).to eq(intro)
    end
  end

  describe '#section_titles' do
    it "returns a list of the section titles" do
      titles = ["Examples", "See also", "References", "Test"]
      expect(expurg.section_titles).to match_array(titles)
    end
  end

  describe '#get_section_by_title' do
    it "returns a section of an article by finding its title" do
      sec = expurg.get_section_by_title('Test')
      expect(sec).to be(test_sec)
    end
  end

end
