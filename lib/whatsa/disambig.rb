class Whatsa::Disambig
  attr_accessor :descriptions
  attr_reader :title, :items

  def initialize(noko_doc)
    @title = noko_doc.css('h1').text
    @items = noko_doc.css('#mw-content-text li')
    @descriptions = make_descriptions
  end

  def choices
    self.descriptions.keys
  end

  def choose_article(choice)
    case choice
    when Fixnum
      Whatsa::Scraper.new(choices[choice - 1]).make_article
    when String
      Whatsa::Scraper.new(choice).make_article
    end
  end

  private

  # make a hash with links and their descriptions
  def make_descriptions
    self.items.inject({}) do |memo, item|
      unless item.css('a').empty?
        memo[item.css('a').first.text] = item.text.split("\n").first.strip
      end
      memo
    end
  end

end
