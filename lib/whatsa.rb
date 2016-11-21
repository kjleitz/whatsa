require_relative '../config/environment'

module Whatsa
end

feces = Whatsa::Article.new(Whatsa::Scraper.new('feces').page)

binding.pry
