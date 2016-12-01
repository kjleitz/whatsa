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

  end
end
