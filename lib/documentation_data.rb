class Scandoc::Documentation_data
  attr_accessor :data, :selected_result_text, :selected_link, :specific

  #@@history = []

  def initialize(word = "")
    @data = {word: word, raw: nil, final: nil}
    @specific = {raw: nil}
    @selected_link = nil
  end

  def add_selected_link_text(i)
    @selected_link = @data[:final][i][:link]
    @selected_result_text = @data[:final][i][:text]
  end

  def add_raw_specific_data
    if @selected_link
      @specific[:raw] = Scandoc::Scraper.scrape_specific_result(@selected_link)
    end
  end

  def organize_search_data
    @data[:raw].sort{|a,b| a.text <=> b.text}

    final = @data[:raw].each_with_index.collect do |e, i|
      organized = {}
      organized[:idx] = i + 1
      organized[:text] = e.text
      organized[:link] = Scandoc::Scraper.path + '/' + e['href']
      organized
    end
    @data[:final] = final
    @data
  end

  def organize_specific_data
    #add header
    @specific[:blurb] = "\n                  #{@selected_result_text.colorize(:color => :light_white)} \n\n"
    @specific[:extended] = ""
    blurbing = true

    raw = @specific[:raw].split('^&*-^')
    #organize by section code and colorize accordingly
    @specific[:colorized] = raw.collect do |str|
      if /^BH/.match(str)
        str = str.slice(2, str.length).colorize(:color => :light_green)
        @specific[:blurb] += str if blurbing
      elsif /^BC/.match(str)
        blurbing = false
        frame = "\n========================================\n".colorize(:color=>:red)
        str = frame + str.slice(2, str.length).colorize(:color => :yellow) + frame
        @specific[:extended] += str
      else
        str = str.slice(2, str.length)
        next unless str
        str = "\n" + str.colorize(:color => :light_white)
        if blurbing
          @specific[:blurb] += str
        else
          @specific[:extended] += str
        end
      end
      str
    end
  end

  # def self.all
  #   @@history
  # end
end
