class Whatsa::Section
  attr_accessor :title, :paragraphs, :article

  def initialize(title, paragraphs)
    @title = title
    @paragraphs = paragraphs
    remove_citations
  end

  def summary
    self.paragraphs.first
  end

  def full_text
    self.paragraphs.join("\n\n")
  end

  private

  def remove_citations
    self.paragraphs.map! do |par|
      par.gsub(/\[\d+\]/, "")
    end
  end

end
