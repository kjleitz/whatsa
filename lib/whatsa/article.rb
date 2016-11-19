class Whatsa::Article
  attr_reader :contents, :title

  def initialize(noko_doc)
    @page = noko_doc
    @title = noko_doc.css('h1').text
    # @contents = make_contents
  end

  def make_contents

  end

  def intro_pars
    content = page.css('#mw-content-text').children
    breakpoint = content.to_a.index { |element| element.name == 'h2' }
    content[0...breakpoint].css('p').map { |par| par.text }
  end

  def summary
    intro_pars.first
  end

  private

  # making the getter private; directly looking at the nokogiri document is a job
  # for the Scraper class... the Article class is for handling the article as an
  # abstract-ish concept
  def page
    @page
  end
end
