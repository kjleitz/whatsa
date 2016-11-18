require_relative 'spec_helper'

describe "Whatsa::Scraper" do

  let(:feces) {Whatsa::Scraper.new('feces')}
  let(:poop) {Whatsa::Scraper.new('poop')}
  let(:jiggly) {Whatsa::Scraper.new('jiggly')}
  let(:gg) {Whatsa::Scraper.new('gobblegobble')}

  it "initializes with a query attribute" do
    expect(feces).to respond_to(:query)
  end

  it "initializes with a page attribute" do
    expect(feces).to respond_to(:page)
  end

  it "turns a search term into a query separated by pluses" do
    gbu = Whatsa::Scraper.new("The Good, The Bad, And The Ugly")
    gbu2 = Whatsa::Scraper.new("'The' Good, The Bad, and 2 or 3 Uggos.")
    good = Whatsa::Scraper.new("good")
    goodbad = Whatsa::Scraper.new("good+, + & ...bad")

    expect(gbu.query).to eq("The+Good+The+Bad+And+The+Ugly")
    expect(gbu2.query).to eq("The+Good+The+Bad+and+2+or+3+Uggos")
    expect(good.query).to eq("good")
    expect(goodbad.query).to eq("good+bad")
  end

  describe '#results_page?' do
    it "returns 'true' for a search results page, and 'false' for anything else" do
      expect(feces.results_page?).to be(false)
      expect(poop.results_page?).to be(false)
      expect(jiggly.results_page?).to be(true)
      expect(gg.results_page?).to be(true)
    end
  end

  describe '#not_found?' do
    it "returns 'true' for a results page with no results, and 'false' for anything else" do
      expect(feces.not_found?).to be(false)
      expect(poop.not_found?).to be(false)
      expect(jiggly.not_found?).to be(false)
      expect(gg.not_found?).to be(true)
    end
  end

  describe '#article?' do
    it "returns 'true' for an article, and 'false' for anything else" do
      expect(feces.article?).to be(true)
      expect(poop.article?).to be(false)
      expect(jiggly.article?).to be(false)
      expect(gg.article?).to be(false)
    end
  end

  describe '#disambig?' do
    it "returns 'true' for a disambiguation page, and 'false' for anything else" do
      expect(feces.disambig?).to be(false)
      expect(poop.disambig?).to be(true)
      expect(jiggly.disambig?).to be(false)
      expect(gg.disambig?).to be(false)

      poop.disambig?.should be_a(TrueClass)
    end
  end

  describe '#make_article' do

    it "returns an Article object from searches that go directly to an article" do
      expect(feces.make_article).to be_a(Whatsa::Article)
    end

    it "returns an Article object from the first entry of a disambiguation page" do
      expect(poop.make_article).to be_a(Whatsa::Article)
    end

    it "returns an Article object from the first entry of a results page" do
      expect(jiggly.make_article).to be_a(Whatsa::Article)
    end

    it "returns 'nil' for searches that matched zero articles" do
      expect(gg.make_article).to be_nil
    end
  end

  describe '#make_disambig' do

    it "returns a Disambig object from searches that go to a disambiguation" do
      expect(poop.make_disambig).to be_a(Whatsa::Disambig)
    end

    it "returns 'nil' for searches that did go to a disambiguation page" do
      expect(feces.make_disambig).to be_nil
      expect(jiggly.make_disambig).to be_nil
      expect(gg.make_disambig).to be_nil
    end
  end

end
