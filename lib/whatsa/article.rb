class Whatsa::Article
  attr_accessor :sections
  attr_reader :contents, :title

  def initialize(noko_doc)
    @title = noko_doc.css('h1').text
    @contents = noko_doc.css('#mw-content-text').children
    @sections = make_sections
  end

  def intro_pars
    breakpoint = self.contents.to_a.index { |element| element.name == 'h2' }
    pars = self.contents[0...breakpoint].css('p').map { |par| par.text }
    pars.reject { |par| par == "" }
  end

  def full_intro
    intro_pars.join("\n\n")
  end

  def summary
    # I might want to make the intro paragraphs their own section, we'll see.
    intro_pars.first
  end

  def section_titles
    self.sections.map { |s| s.title }
  end

  def get_section_by_title(title)
    self.sections.find { |s| s.title == title }
  end

  private

  def make_sections
    indices = section_indices
    indices << -1
    secs = []
    indices.each_cons(2) do |i, j|
      title = self.contents[i].text.gsub('[edit]', '').strip
      par_nodes = self.contents[i...j].select { |e| e.name == 'p' && e.text != "" }
      pars = par_nodes.map { |par| par.text }
      secs << Whatsa::Section.new(title, pars)
    end
    secs
  end

  def section_indices
    indices = []
    self.contents.each_with_index do |element, i|
      indices << i if element.name == 'h2'
    end
    indices
  end
end
