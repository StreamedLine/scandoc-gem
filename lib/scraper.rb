require "open-uri"
require "nokogiri"

class Scandoc::Scraper
  BASE_PATH = "http://ruby-doc.org/core"

  def self.search_hrefs(hrefs, keyword)
    hrefs.collect do |e|
      e if Regexp.new(keyword).match(e.text)
    end.compact
  end

  def self.scrape_the_doc(keyword)
    page = open(BASE_PATH)
    hrefs = Nokogiri::HTML(page).css("a")
    results = search_hrefs(hrefs, keyword)
  end

  def self.traverseIt(chunk)
    chunk = chunk.children[0]
    result = ""
    while chunk.next
      if chunk.name == 'div'
        result += "#{traverseIt(chunk)}"
        chunk = chunk.next
        next
      end
      if chunk.name == 'pre'
        result += "^&*-^BC"
        result += chunk.inner_text.gsub('\r' , "").strip
      else
        if chunk.inner_text.split(" ").uniq.count < 2
          chunk = chunk.next
          next
        end
        result += "^&*-^BB"
        result += chunk.inner_text if chunk.inner_text && chunk.inner_text != "\n" && chunk.name != 'a'
      end
      chunk = chunk.next
    end
    result
  end

  def self.scrape_specific_result(link)
    page = open(link)
    html = Nokogiri::HTML(page)
    scrape = html.css('a').detect {|n| n['name'] == "#{link.split('#')[1]}"}.parent
    #discard irelevant data
    scrape.search('.method-click-advice').each{|e| e.remove}
    scrape.search('div > a').each{|e| e.remove}
    #collect and discard data
    result = "^&*-^BH"
    scrape.search('.method-callseq').each do |e|
      result += "#{e.inner_text}\n"
    end
    scrape.search('.method-callseq').each{|e| e.remove}
    result += traverseIt(scrape)
  end

  def self.path
    BASE_PATH
  end

end
