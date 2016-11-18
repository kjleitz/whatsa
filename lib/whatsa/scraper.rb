class Whatsa::Scraper
  attr_reader :query, :page

  WIKISEARCH = 'https://en.wikipedia.org/w/index.php?search='

  def initialize(term)
    # only keep word chars, turn everything between each 'word' to a single '+'
    # and remove '+'s at the beginning and end if they're there
    @query = term.gsub(/\W+/, '+').gsub(/(\A\+|\+\z)/, '')
    @page = Nokogiri::HTML(open(WIKISEARCH + self.query))
  end

  def results_page?
    !self.page.css('.searchresults').empty?
  end

  def not_found?
    !self.page.css('.mw-search-nonefound').empty?
  end

end

feces = Whatsa::Scraper.new("feces")      # search term that exists exactly
poop = Whatsa::Scraper.new("poop")        # search term that redirects
jiggly = Whatsa::Scraper.new("jiggly")    # search term that has results
gg = Whatsa::Scraper.new("gobblegobble")  # search term that has no results

binding.pry
