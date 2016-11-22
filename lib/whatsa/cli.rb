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
      when "new"
        run
      else
        break
      end
    end
    input
  end

  def display_dmb(dmb)
    raise TypeError unless dmb.is_a?(Whatsa::Disambig)
    system("clear")
    puts "Hmmm... #{dmb.title} could mean a few different things:\n"
    dmb.descriptions.each_with_index do |kvp, i|
      puts "#{i + 1}. #{kvp[0].to_s} (#{kvp[1]})"
    end
    puts "\nPlease select a choice, either by name or number."
  end

  def display_sections(text)
    text = text.article if text.is_a?(Whatsa::Section)
    system("clear")
    puts "Here are some specific subjects about '#{text.title}':\n"
    text.section_titles.each_with_index {|title, i| puts "#{i + 1}. #{title}"}
    puts "\nPlease select a choice, either by name or number."
  end

  def summary_helpline
    puts "_______________________________________________________________"
    puts "(type 'more' for a potentially longer summary, 'other' if you'd"
    puts "like to select a specific category of information on the topic,"
    puts "          or 'new' to find out about something else)"
  end

  def full_text_helpline
    puts "____________________________________________________________________"
    puts "   (type 'other' if you'd like to select a specific category of"
    puts "information on the topic, or 'new' to find out about something else)"
  end

  def summarize(text)
    system("clear")
    puts text.summary
    summary_helpline
    input = gets_command
    input.downcase == "more" ? full(text) : input
  end

  def full(text)
    system("clear")
    puts text.full_text
    full_text_helpline
    gets_command
  end

  def choose_category
    display_sections
    choice = gets_command
    section = article.choose_section(choice)
    summarize(section)
  end

  def run
    welcome
    instructions
    loop do
      ask

      # get a search term
      input = gets_command
      scraper = Whatsa::Scraper.new(input)

      # get an article from the search, or restart the loop if it can't be found
      if scraper.not_found?
        puts "Hmmm... I don't know what '#{input}' means! Try something else."
        next
      elsif scraper.disambig?
        dmb = scraper.make_disambig
        display_dmb(dmb)
        choice = gets_command
        article = dmb.choose_article(choice)
      else
        article = scraper.make_article
      end

      # summarize that article
      input = summarize(article)

      # the only valid input here that would go uncaught is "other", so
      # keep asking until you get a caught input (logic determined by
      # #gets_command, e.g. "help", "exit", "new") or "other"
      loop { input = input.downcase == "other" ? choose_category : gets_command }

    end
  end
end
