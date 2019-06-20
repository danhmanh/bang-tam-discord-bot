require "mechanize"
require "pry"

module CrawlerChords
  $agent = Mechanize.new

  def self.markdownize_lyrics content
    content.gsub! "[", " `["
    content.gsub! "]", "]` "

    content
  end

  def self.get_lyrics url
    page = $agent.get url
    lyrics = page.search "div.chord_lyric_line"
    content = ""
    song_title = page.search("h1#song-title").inner_text.strip
    singer = page.search("span.perform-singer-list").inner_text.gsub!(/\s+/, ' ')
    key = page.search("a#display-key").inner_text.strip
    rhythm = page.search("span#display-rhythm").inner_text.strip

    note = page.search("div.song-lyric-note").inner_text.gsub(/\s+/, '').strip
    about = "#{song_title} - #{singer}\n#{key} - #{rhythm}"
    content << about << "\n"
    lyrics.map{ |line| content << "#{line.inner_text}\n" }
    content = markdownize_lyrics(content)[0..1500]
  end

  def self.search_song keyword
    keyword.gsub!(" ", "%20")
    url = "https://hopamchuan.com/search?q=#{keyword}"
    page = $agent.get url
    results = page.search("div.song-title-singers")
    arr = []
    results[0..4].each_with_index do |result, index|
      url = result.search("a.song-title").attr("href").value
      arr.push({index: index + 1,
        title: result.inner_text.gsub(/\s+/, ' ').strip,
        url: url})
    end
    return arr
  end

  def self.get_result_search arr
    message = "Đã tìm thấy #{arr.size} kết quả\n"
    arr.each do |element|
      message << "#{element[:index]}. #{element[:title]}\n"
    end

    message
  end

end


