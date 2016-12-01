class Whatsa::Article
  # I think this is a bad use of include. I feel like I _should_ make Format a
  # class and use its methods that way, but I'm going to be using them so often
  # that I would prefer they not be referenced as Whatsa::Format.blah_blah every
  # time...
  include Whatsa::Format

  attr_accessor :sections
  attr_reader :contents, :title

  def initialize(noko_doc)
    @title = noko_doc.css('h1').text
    @contents = noko_doc.css('#mw-content-text').children
    @sections = make_sections

    # comment out the next line if you want sections with non-<p> and non-<ul>
    # content to display as "[no displayable information]"
    remove_empty_sections
  end

  def summary
    self.sections.first.summary
  end

  def full_text
    # name might be a little confusing: it's not really the "full text" of the
    # article, it's the full text of the article summary. I'm naming it #full_text
    # for duck-typing reasons
    self.sections.first.full_text
  end

  def section_titles
    self.sections.map { |s| s.title }
  end

  def choose_section(choice)
    if choice.to_i > 0
      self.sections[choice.to_i - 1]
    else
      get_section_by_title(title)
    end
  end

  private

  def get_section_by_title(title)
    self.sections.find { |s| s.title.downcase == title.downcase }
  end

  def intro_pars
    breakpoint = self.contents.to_a.index { |element| element.name == 'h2' }
    breakpoint ||= -1 # breakpoint would be nil for zero-section articles
    pars = self.contents[0...breakpoint].css('p').map { |par| par.text }
    pars.reject { |par| par == "" }
  end

  def make_sections
    indices = section_indices
    indices << -1
    secs = [Whatsa::Section.new("#{self.title} - Introduction", intro_pars)]
    indices.each_cons(2) do |i, j|
      title = heading_to_title(self.contents[i].text)
      par_nodes = self.contents[i...j].select do |e|
        e.name == 'p' || e.name == 'ul' && e.text != ""
      end
      pars = par_nodes.map { |par| par.text.strip }
      secs << Whatsa::Section.new(title, pars).tap { |s| s.article = self }
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

  def remove_empty_sections
    self.sections.reject! { |sec| sec.summary == "[no displayable information]" }
  end
end
