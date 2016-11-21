class Whatsa::CLI

  def welcome
    system('clear')
    puts "Whatsa is a quick-and-dirty lookup utility, powered by Wikipedia!"
    puts "-----------------------------------------------------------------"
  end

  def instructions
    puts "Enter a word (or phrase) to get a brief summary of that subject."
    puts "If you aren't satisfied, type 'more' to get a slightly longer"
    puts "description, or type 'other' to get a list of specific categories"
    puts "regarding that subject, which you can choose by number or name."
    puts "You can type 'exit' to close the program (or 'help' to receive"
    puts "these instructions again) at any time!"
  end

  def ask
    puts "What would you like to know about?"
    gets_command
  end

  def gets_command
    input = nil
    loop do
      input = gets.strip
      case input
      when ""
        puts "Please enter a valid input."
      when "exit"
        exit
      when "help"
        instructions
      else
        break
      end
    end
    input
  end

  def display_dmb(dmb)
    raise TypeError unless dmb.is_a?(Whatsa::Disambig)
    puts "Hmmm... #{dmb.title} could mean a few different things:\n"
    dmb.descriptions.each_with_index do |kvp, i|
      puts "#{i + 1}. #{kvp[0].to_s} (#{kvp[1]})"
    end
    puts "\nPlease select a choice, either by name or number."
  end

  def run
    welcome
    instructions
    loop do
      input = gets_command
      scraper = Whatsa::Scraper.new(input)
      if scraper.not_found?
        puts "Hmmm... I don't know what '#{input}' means! Try something else."
      elsif scraper.disambig?
        dmb = scraper.make_disambig
        display_dmb(dmb)
        choice = gets_command
        article = dmb.choose_article(choice)
      else
        article = scraper.make_article
      end
      puts article.summary
    end
  end

end
