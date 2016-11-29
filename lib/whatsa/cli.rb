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
      print "> "
      input = gets.strip.downcase
      case input
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

  def word_wrap(text)
    count = 0
    words = text.split(/ /)
    words.each_with_index do |word, index|
      count += word.length + 1
      if count > 80
        words.insert(index, "\n")
        count = 0
      elsif word.index("\n")
        count = word.length
      end
    end
    words.join(" ").gsub(/^ /, "")
  end

  def display_dmb(dmb)
    raise TypeError unless dmb.is_a?(Whatsa::Disambig)
    system("clear")
    stripped_title = dmb.title.gsub("(disambiguation)", "").strip
    puts "Hmmm... #{stripped_title} could mean a few different things:\n"
    dmb.descriptions.each_with_index do |kvp, i|
      desc = kvp[1].empty? ? "" : " - #{kvp[1]}"
      puts "#{i + 1}. #{kvp[0].to_s}" + desc
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
    puts "   _______________________________________________________________"
    puts "   (type 'more' for a potentially longer summary, 'other' if you'd"
    puts "   like to select a specific category of information on the topic,"
    puts "             or 'new' to find out about something else)"
  end

  def full_text_helpline
    puts "   _______________________________________________________________"
    puts "    (type 'other' if you'd like to select a specific category of"
    puts " information on the topic, or 'new' to find out about something else)"
  end

  def get_dmb_choice(disambig)
    display_dmb(disambig)
    choice = nil
    loop do
      choice = gets_command
      in_choices = disambig.choices.detect { |c| c.downcase == choice }
      break if in_choices || choice.to_i > 0
    end
    disambig.choose_article(choice)
  end

  def get_sec_choice(article)
    display_sections(article)
    choice = gets_command
    article.choose_section(choice)
  end

  def summarize(text)
    system("clear")
    return full(text) if text.summary == text.full_text
    puts word_wrap(text.summary)
    summary_helpline
    input = gets_command
    input == "more" ? full(text) : input
  end

  def full(text)
    system("clear")
    puts word_wrap(text.full_text)
    full_text_helpline
    gets_command
  end

  def run
    welcome
    instructions

    # get a search term
    input = ask
    scraper = Whatsa::Scraper.new(input)

    # get an article from the search, or restart the loop if it can't be found
    if scraper.not_found?
      print "Hmmm... I don't know what '#{input}' means!\nPress 'enter' to try something else."
      gets
      run
    elsif scraper.disambig?
      article = get_dmb_choice(scraper.make_disambig)
    else
      article = scraper.make_article
    end

    # summarize that article
    input = summarize(article)

    # the only valid input here that would go uncaught is "other", so
    # keep asking until you get a caught input (logic determined by
    # #gets_command, e.g. "help", "exit", "new") or "other"
    loop { input = input == "other" ? summarize(get_sec_choice(article)) : gets_command }
  end
end
