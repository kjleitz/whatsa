class Whatsa::Article
  attr_accessor :sections
  attr_reader :contents, :title

  def initialize(noko_doc)
    @contents = noko_doc.css('#mw-content-text').children
    @title = noko_doc.css('h1').text
    @sections = []
    make_sections
  end

  def intro_pars
    breakpoint = self.contents.to_a.index { |element| element.name == 'h2' }
    pars = self.contents[0...breakpoint].css('p').map { |par| par.text }
    pars.reject { |par| par == "" }
  end

  def summary
    # this may go... might want to make the intro paragraphs their own
    # section object
    intro_pars.first
  end

  private

  def make_sections
    indices = section_indices
    indices << -1
    indices.each_cons(2) do |i, j|
      title = self.contents[i].text
      par_nodes = self.contents[i...j].select { |e| e.name == 'p' && e.text != "" }
      pars = par_nodes.map { |par| par.text }
      self.sections << Whatsa::Section.new(title, pars)
    end
  end

  def section_indices
    indices = []
    self.contents.each_with_index do |element, i|
      indices << i if element.name == 'h2'
    end
    indices
  end
end
