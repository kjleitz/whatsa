class Whatsa::Section
  attr_accessor :title, :paragraphs, :article

  def initialize(title, paragraphs)
    @title = title
    @paragraphs = paragraphs
    remove_citations
  end

  def summary
    self.paragraphs.first || "[no displayable information]"
  end

  def full_text
    self.paragraphs.empty? ? "[no displayable information]" : self.paragraphs.join("\n\n")
  end

  private

  def remove_citations
    self.paragraphs.map! { |par| par.gsub(/\[(\d+|citation needed)\]/, "") }
  end

end
