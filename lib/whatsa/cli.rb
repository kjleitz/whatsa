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
    system("clear")
    puts "Hmmm... #{dmb.title} could mean a few different things:\n"
    dmb.descriptions.each_with_index do |kvp, i|
      puts "#{i + 1}. #{kvp[0].to_s} (#{kvp[1]})"
    end
    puts "\nPlease select a choice, either by name or number."
  end

  def display_sections(article)
    raise TypeError unless article.is_a?(Whatsa::Article)
    system("clear")
    puts "Here are some specific subjects about '#{article.title}':\n"
    article.section_titles.each_with_index {|title, i| puts "#{i + 1}. #{title}"}
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
      system("clear")
      puts article.summary
      summary_helpline
      input = gets_command
      case input
      when "more"
        system("clear")
        puts article.full_intro
        full_text_helpline
        # need to get input here. if you set it to 'input', will it
        # continue the case?
      when "other"
        # list categories
        display_sections(article)
        choice = gets_command
        section = article.choose_section(choice)
        system("clear")
        puts section.summary
        summary_helpline
        input = gets_command
        case input
        when "more"
          system("clear")
          puts section.full_text
          full_text_helpline
        when "other"
          # list categories again
        end
      end
    end
  end

end
