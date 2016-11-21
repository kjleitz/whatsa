require_relative '../config/environment'

module Whatsa
end

feces = Whatsa::Article.new(Whatsa::Scraper.new('feces').page)
poop = Whatsa::Disambig.new(Whatsa::Scraper.new('poop').page)

binding.pry
