class Whatsa::CLI
  # I think this is a bad use of include. I feel like I _should_ make Format a
  # class and use its methods that way, but I'm going to be using them so often
  # that I would prefer they not be referenced as Whatsa::Format.blah_blah every
  # time...
  include Whatsa::Format

  def clear_screen
    50.times { puts "\n" }
    system('clear')
  end

  def welcome
    clear_screen
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
    puts ""
  end

  def ask
    puts "What would you like to know about?"
    gets_command(true)
  end

  def gets_command(treat_as_query = false)
    command_type = {
      "exit" => "exit",
      "quit" => "exit",
      "q"    => "exit",

      "help"         => "help",
      "h"            => "help",
      "instructions": ("help" unless treat_as_query),

      "new"            => "new",
      "different"      => ("new" unless treat_as_query),
      "something else" => ("new" unless treat_as_query),
      "again"          => ("new" unless treat_as_query),

      "other"      => ("other" unless treat_as_query),
      "categories" => ("other" unless treat_as_query),
      "category"   => ("other" unless treat_as_query),
      "dig"        => ("other" unless treat_as_query),

      "" => "blank"
    }

    loop do
      print "> "
      input = gets.strip.downcase
      case command_type[input]
      when "exit"  then exit
      when "help"  then instructions
      when "new"   then return run
      when "other" then return "other"
      when ""      then next
      else return input
      end
    end
  end

  def display_dmb(dmb)
    raise TypeError unless dmb.is_a?(Whatsa::Disambig)
    clear_screen
    stripped_title = dmb.title.gsub("(disambiguation)", "").strip
    puts word_wrap("Hmmm... #{stripped_title} could mean a few different things:\n")
    dmb.descriptions.each_with_index do |kvp, i|
      num = "#{i + 1}. "
      item = "#{kvp[0].to_s}"
      desc = kvp[1].empty? ? "" : " - #{kvp[1]}"
      puts word_wrap(num + item + desc, num.length)
    end
    puts "\nPlease select a choice, either by name or number."
  end

  def display_sections(text)
    text = text.article if text.is_a?(Whatsa::Section)
    clear_screen
    puts word_wrap("Here are some specific subjects about '#{text.title}':\n")
    text.section_titles.each_with_index do |title, i|
      puts word_wrap("#{i + 1}. #{title}", "#{i + 1}. ".length)
    end
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
      puts "Hmm... I don't think that's a valid choice. Try again!"
    end
    disambig.choose_article(choice)
  end

  def get_sec_choice(article)
    display_sections(article)
    loop do
      choice = gets_command
      section = article.choose_section(choice)
      return section if section
      puts "Hmm... I don't think that's a valid section. Try again!"
    end
  end

  def summarize(text)
    clear_screen
    return full(text) if text.summary == text.full_text
    puts word_wrap(text.summary)
    summary_helpline
    input = gets_command
    input == "more" ? full(text) : input
  end

  def full(text)
    clear_screen
    puts word_wrap(text.full_text)
    full_text_helpline
    gets_command
  end

  def run
    # This is the main method for running the CLI.
    # It consists of three main parts:
    # Part one - decorative - Welcome the user, give instructions for use
    # Part two - initialize - Get a query from the user and try to make an
    #                         article out of whatever comes back (results page,
    #                         disambiguation page, or article)
    # Part three - article  - We've gotten to an article, display it to the user
    #                         and loop as long as they wish to select different
    #                         sections

    if ARGV.empty?

      ##########
      # PART ONE

      welcome
      instructions

      ##########
      # PART TWO

      # get a search term
      input = ask

    else
      input = ARGV.join(" ")
      ARGV.clear
    end

    scraper = Whatsa::Scraper.new(input)

    # get an article from the search, or restart the loop if it can't be found
    if scraper.not_found?
      print word_wrap("Hmmm... I don't know what '#{input}' means!\nPress 'enter' to try something else.")
      gets
      run
    elsif scraper.disambig?
      article = get_dmb_choice(scraper.make_disambig)
    else
      article = scraper.make_article
    end


    ############
    # PART THREE

    # summarize that article
    input = summarize(article)

    # the only valid input here that would go uncaught is "other", so
    # keep asking until you get a caught input (logic determined by
    # #gets_command, e.g. "help", "exit", "new") or "other"
    loop { input = input == "other" ? summarize(get_sec_choice(article)) : gets_command }
  end
end
