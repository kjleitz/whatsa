class Whatsa::Article
  attr_reader :contents, :title

  def initialize(noko_doc)
    @page = noko_doc
    @contents = noko_doc.css('#mw-content-text').children
    @title = noko_doc.css('h1').text
    # @contents = make_contents
  end

  def make_contents

  end

  def intro_pars
    breakpoint = self.contents.to_a.index { |element| element.name == 'h2' }
    self.contents[0...breakpoint].css('p').map { |par| par.text }
  end

  def summary
    # this may go... might want to make the intro paragraphs their own
    # section object
    intro_pars.first
  end

  def make_sections

  end

  private

  # making the getter private; directly looking at the nokogiri document is a job
  # for the Scraper class... the Article class is for handling the article as an
  # abstract-ish concept
  def page
    @page
  end

  def section_indices
    indices = []
    self.contents.each_with_index do |element, i|
      indices << i if element.name == 'h2'
    end
    indices
  end
end
