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
    content_text = noko_doc.css('#mw-content-text')
    wiki_parser_output = content_text.css('.mw-parser-output') # no idea why wiki is structured like this
    @contents = wiki_parser_output.empty? ? content_text.children : wiki_parser_output.children
    @sections = build_sections(noko_doc)

    # comment out the next line if you want sections with non-<p> and non-<ul>
    # content to display as "[no displayable information]"
    remove_empty_sections
  end

  def summary
    return no_text_found for_subject: 'summary' if sections.empty?
    sections.first.summary
  end

  def full_text
    return no_text_found for_subject: 'full summary' if sections.empty?
    # name might be a little confusing: it's not really the "full text" of the
    # article, it's the full text of the article summary. I'm naming it #full_text
    # for duck-typing reasons
    sections.first.full_text
  end

  def section_titles
    sections.map { |s| s.title }
  end

  def choose_section(choice)
    if choice.to_i > 0
      sections[choice.to_i - 1]
    else
      get_section_by_title(choice)
    end
  end

  private

  def no_text_found(for_subject: title)
    "[no text found for #{for_subject}]"
  end

  def get_section_by_title(section_title)
    sections.find { |s| s.title.downcase == section_title.downcase }
  end

  def intro_pars
    wiki_parser_output = contents.css('.mw-parser-output') # no idea why wiki is structured like this
    content_nodes = wiki_parser_output.empty? ? contents : wiki_parser_output
    breakpoint = content_nodes.to_a.index { |element| element.name == 'h2' }
    breakpoint ||= -1 # breakpoint would be nil for zero-section articles
    pars = content_nodes[0...breakpoint].css('p').map { |par| par.text }
    pars.reject { |par| par == "" }
  end

  def build_sections(noko_doc)
    headers = noko_doc.css('.mw-headline').map(&:parent)
    sects = headers.map do |header|
      title = heading_to_title(header.text)
      nodes = build_section_nodes(header.name, header).map { |node| node.text.strip }
      Whatsa::Section.new(title, nodes).tap { |section| section.article = self }
    end
    [Whatsa::Section.new("#{title} - Introduction", intro_pars), *sects]
  end

  def build_section_nodes(header_level, start_node, siblings = [])
    next_sib = start_node.next_sibling
    return siblings if next_sib.nil?
    return siblings if next_sib.name =~ /^h\d$/i && header_level =~ /^h\d$/i && next_sib.name <= header_level

    include_node = %w(p ul ol h1 h2 h3 h4 h5 h6).include?(next_sib.name) && !next_sib.text.strip.empty?
    build_section_nodes(header_level, next_sib, include_node ? [*siblings, next_sib] : siblings)
  end

  def remove_empty_sections
    sections.reject! { |sec| sec.summary == "[no displayable information]" }
  end
end
