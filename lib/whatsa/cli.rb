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
    gets.strip
  end

  def run
    welcome
    instructions
    loop do
      input = ask
      case input
      when ""
        puts "Please enter a word or phrase."
      when "exit"
        break
      when "help"
        instructions
      else
        scraper = Whatsa::Scraper.new(input)
        if scraper.disambig?
          dmb = scraper.make_disambig
          puts "Hmmm... #{input} could mean a few different things:"
          dmb.descriptions.each do |key, val|
            
          end
      end
    end
  end

end
