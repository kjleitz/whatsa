class Whatsa::Section
  # I think this is a bad use of include. I feel like I _should_ make Format a
  # class and use its methods that way, but I'm going to be using them so often
  # that I would prefer they not be referenced as Whatsa::Format.blah_blah every
  # time...
  include Whatsa::Format
  
  attr_accessor :title, :paragraphs, :article

  def initialize(title, paragraphs)
    @title = title
    @paragraphs = paragraphs
    remove_citations
    bullet_list_pars
  end

  def summary
    self.paragraphs.first || "[no displayable information]"
  end

  def full_text
    self.paragraphs.empty? ? "[no displayable information]" : self.paragraphs.join("\n\n")
  end

  private

  def remove_citations
    self.paragraphs.map! { |par| remove_citation_markers(par) }
  end

  def bullet_list_pars
    self.paragraphs.map! { |par| bulletize_lines(par) }
  end

end
