module Whatsa
  module Format

    def url_friendly(string)
      string.gsub(/[^A-z0-9\(\)]+/, '+').gsub(/(\A\+|\+\z)/, '')
    end

    def heading_to_title(string)
      string.gsub('[edit]', '').strip
    end

    def remove_citation_markers(string)
      string.gsub(/\[(\d+|citation needed)\]/, "")
    end

    def bulletize_lines(string)
      string.index("\n") ? string.gsub(/^/, "- ") : string
    end

    # setting an indent will indent the lines AFTER the first line of a paragraph
    def word_wrap(text, indent=0)
      count = 0
      words = text.split(/ /)
      words.each_with_index do |word, index|
        count += word.length + 1
        if count > 80
          words.insert(index, "\n#{' ' * indent}")
          count = indent
        elsif word.index("\n")
          count = word.length
        end
      end
      words.join(" ").gsub(/^ /, "")
    end

  end
end
