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
      if string.index("\n")
        list = string.gsub(/^/, "- ")
        word_wrap(list, "- ".length)
      else
        string
      end
    end

    # setting an indent will indent the lines AFTER the first line of a paragraph
    def word_wrap(text, indent=0)
      chars = text.split(//)
      unless text.length < 80
        count = 1
        last_space = 80
        chars.each_with_index do |char, index|
          count += 1
          last_space = index if char.match(/ /)
          if char == "\n"
            count = indent
          elsif count == 80
            chars[last_space] = "\n#{" " * indent}"
            count = indent + index - last_space
          end
        end
      end
      chars.join
    end

  end
end
