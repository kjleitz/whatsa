class Whatsa::Section
  attr_accessor :title, :paragraphs, :article

  def initialize(title, paragraphs)
    @title = title
    @paragraphs = paragraphs
  end

  def summary
    self.paragraphs.first
  end

  def full_text
    self.paragraphs.join("\n\n")
  end

end
