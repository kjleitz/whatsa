module Whatsa
  module Format

    def url_friendly(string)
      string.gsub(/[^A-z0-9\(\)]+/, '+').gsub(/(\A\+|\+\z)/, '')
    end

    
  end
end
