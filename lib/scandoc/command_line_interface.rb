require "colorize"
require "clipboard"
require "launchy"

class Scandoc::CommandLineInterface
  def initialize(keyword)
    @keyword = keyword
    @data = Scandoc::Documentation_data.new(keyword)
  end

  def run
    collect_doc_refs #searches the doc/core
    organize_search_data #puts it into objects and sorts them
    display_search_results #displays 10 at a time

    collect_specific_data #collects user specified data
    organize_specific_data #organizes it into objects
    display_specific_result #displays data

    launch_browser? #optional browser launch with cliboard copy as fallback
  end

  def smart_input(rules, msg)
    puts msg
    input = STDIN.gets.chomp
    while rules.all?{|r| r.match(input) == nil}
      if input.upcase == 'Q' or input.upcase == 'QUIT'
        #end program elegently
        exit
      else
        puts msg
        input = STDIN.gets.chomp
      end
    end
    input
  end

  #Step 1

  def collect_doc_refs
    #scrape doc for references to keyword
    @data.data[:raw] = Scandoc::Scraper.scrape_the_doc(@keyword)
  end

  def organize_search_data
    @data.organize_search_data
  end

  def display_search_results
    if @data.data[:final].length == 0
      puts "\nSorry, #{@keyword} was not found.\nPress any key to quit."
      STDIN.gets
      return
    end
    input = ""
    @data.data[:final].each_with_index do |result, i|
      puts ""
      puts "#{result[:idx]}. #{result[:text].colorize(:yellow)}\n#{result[:link].colorize(:light_blue)}"

      if i > 1 and i % 10 == 0
        input = smart_input([/\d/, ""], "\npress [any key] to display next 10 results\n\n(enter link number to display result)")
        break if input && input != ""
      end
    end
    if !input or input == ""
      input = smart_input([/\d/], "\nenter link number to display result or 'q' to quit")
    end
    exit unless input.to_i.between?(1, @data.data[:final].count)
    @data.add_selected_link_text(input.to_i - 1)
  end

  #Step 2

  def collect_specific_data
    @data.add_raw_specific_data
  end

  def organize_specific_data
    @data.organize_specific_data
  end

  def display_specific_result
    puts @data.specific[:blurb]
    puts @data.specific[:extended]
  end


  def launch_browser?
    link = @data.selected_link
    puts "Type b to display in browser or any key to quit".colorize(:color => :cyan)
    browser = STDIN.gets.chomp
    if browser.upcase == 'B'
      begin
         Launchy.open(link)
      rescue
        puts "Couldn't access browser. Link will be copied to clipboard instead.".colorize(:red)
        Clipboard.copy(link)
        puts "#{link.colorize(:light_blue)} copied to cliboard!"
      end
      true
    else
      false
    end
  end
end
