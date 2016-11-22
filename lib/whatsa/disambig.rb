class Whatsa::Disambig
  attr_accessor :descriptions
  attr_reader :title, :items

  def initialize(noko_doc)
    @title = noko_doc.css('h1').text
    @items = noko_doc.css('#mw-content-text li')
    @descriptions = make_descriptions
  end

  def choices
    self.descriptions.keys
  end

  def choose_article(choice)
    if choice.to_i > 0
      Whatsa::Scraper.new(choices[choice.to_i - 1]).make_article
    else
      Whatsa::Scraper.new(choice).make_article
    end
  end

  private

  # make a hash with links and their descriptions
  def make_descriptions
    self.items.inject({}) do |memo, item|
      unless item.css('a').empty?
        key = item.css('a').first.text
        toc_link = item["class"] && item["class"].match(/toc/)
        dmb_link = key.match("(disambiguation)")
        all_link = key.match("All pages with titles")
        unless toc_link || dmb_link || all_link
          desc = item.text.split("\n").first.strip
          memo[key] = desc.gsub(key, "").gsub(/\A[^\w"]/, "").strip
        end
      end
      memo
    end
  end

end
