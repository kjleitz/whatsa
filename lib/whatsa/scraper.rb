class Whatsa::Scraper
  include Whatsa::Format
  # Should not include this like this

  WIKISEARCH = 'https://en.wikipedia.org/w/index.php?search='

  attr_reader :query, :page

  def initialize(term)
    # only keep word chars and parens, turn everything between each 'word'
    # to a single '+' and remove '+'s at the beginning and end if they're there
    @query = url_friendly(term)

    # store the page in an instance variable so we don't keep polling the site
    @page = Nokogiri::HTML(open(WIKISEARCH + self.query))
  end

  def results_page?
    !self.page.css('.searchresults').empty?
  end

  def not_found?
    !self.page.css('.mw-search-nonefound').empty?
  end

  def article?
    !self.page.css('#ca-nstab-main').empty? && !disambig?
  end

  def disambig?
    !self.page.css('#disambigbox').empty?
  end

  def make_article
    if article?
      Whatsa::Article.new(self.page)
    elsif results_page? && !not_found?
      first_title = self.page.css('.mw-search-results li a').first.text
      self.class.new(first_title).make_article
    elsif disambig?
      self.class.new(make_disambig.choices.first).make_article
    else
      nil
    end
  end

  def make_disambig
    disambig? ? Whatsa::Disambig.new(self.page) : nil
  end
end
