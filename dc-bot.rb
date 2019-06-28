require "discordrb"
require "rest-client"
require "pry"
require "sequel"
require "wit"
require "mechanize"
require "dotenv"
require "dentaku"

require_relative "db"
require_relative "sound_of_text"
require_relative "weather_api"
require_relative "wit_api"
require_relative "crawler_chords"
require_relative "discord_helper"

class Bot

  Dotenv.load
  TOKEN = ENV.fetch("TOKEN")
  CLIENT_ID = ENV.fetch("CLIENT_ID")
  WIT_ACCESS_TOKEN = ENV.fetch("WIT_ACCESS_TOKEN")
  WEATHER_APP_ID = ENV.fetch("WEATHER_APP_ID")

  bot = Discordrb::Commands::CommandBot.new token: TOKEN, client_id: CLIENT_ID, prefix: ",", ignore_bots: false
  calculator = Dentaku::Calculator.new

  puts bot.invite_url
  # Quick math
  MINATO = 392833205348204546
  RDVN_CHANNEL = 507536460560465940
  DEV_CHANNEL = 585358453573156867

  bot.message(from: MINATO, in: RDVN_CHANNEL) do |event|
    unless event.message.embeds.empty?
      title = event.message.embeds[0].author.name

      if title.include?("Quick math")

        event.message.react "💡"

        bot.add_await(:"check_math#{event.message.id}", Discordrb::Events::ReactionAddEvent, emoji: "💡") do |reaction_event|
          nickname = reaction_event.user.nickname.gsub(" ", "")
          if DB.check_math_user(reaction_event.user)
            #  && nickname == event.message.embeds.first.footer.text.delete("Request by d")
            question = event.message.embeds[0].description
            math_str = question.split("\n").first
            DiscordHelper.embed_message event.channel, "💋 #{calculator.evaluate(math_str)} 💋"
          else
            DiscordHelper.embed_message event.channel, "Này <@#{reaction_event.user.id}>, nộp cho rain **2000π** rồi em sẽ bày toán cho 💵\n
              Dịch vụ uy tín 🛡 chất lượng 🛡 tính sai không lấy tiền"
          end
        end


      end

    end
  end

  bot.command :add_math do |event|
    next if event.user.id != 388659492071669760
    user = event.message.mentions.first
    if user
      DB.add_math_user user
      DiscordHelper.embed_message event.channel, "🤝 🤝 Cảm ơn #{user.username} đã tin tuởng sử dụng dịch vụ của chúng tôi 🤝 🤝"
    end
  end

  bot.mention do |event|
    message = event.message.content.delete("<@582975188719894583>").strip
    rsp = WitAPI.send_message message
    begin
      event.respond "#{ WeatherAPI.get_message(rsp)}"
    rescue
      # Question mark ❓
      event.message.react "\u2753"
    end
  end



  # bot.command :private do |event, type|
  #   user = event.user
  #   private_channel = event.server.create_channel(user.username, 2)
  #   event.server.move(event.user.id, private_channel.id)
  #   private_channel.delete if private_channel.users.count == 0
  # end

  bot.command :chord do |event, *args|
    song_name = args.join(" ")
    arr = CrawlerChords.search_song song_name
    DiscordHelper.embed_message event.channel, CrawlerChords.get_result_search(arr)

    event.user.await(:choice) do |choice_event|
      choice = choice_event.message.content.to_i
      url = arr.select{|song| song[:index] == choice}.first[:url]
      DiscordHelper.embed_message event.channel, CrawlerChords.get_lyrics(url)
    end

    nil
  end

  bot.command :game do |event|
    username = event.message.user.username
    first_num = rand(1..100)
    sec_num = rand(1..100)

    event.user.await(:guess) do |guess_event|

      if guess_event.message.content.start_with? "="
        user = guess_event.message.user
        guess = guess_event.message.content.delete("=").to_i
        if guess == first_num + sec_num
          begin
            DB.add_point(user)
            current_point = DB.get_point(user)

            respond = "<@#{user.id}> trả lời chính xác. Bạn đang có #{current_point}p."
            guess_event.respond respond
          rescue
            guess_event.respond "Bot hỏng mịa rồi. Gọi rain ngay !"
          end
        end
      end

      true
    end

    event.respond "**QUICK MATH:** Trả lời có dấu = đằng trước ví dụ: =100"
    event.respond  "```#{first_num} + #{sec_num}```"

  end

  bot.command :rank do |event|
    event.respond "<@#{event.message.user.id}>, bảng xếp hạng (tính theo money)"
    event.respond DB.get_all
  end

  bot.command :choose do |event|
    str = event.message.content
    choice = str.sub(".choose ", "").split(",").map(&:strip).sample
    username = event.message.user.username
    event.respond "Nếu em là #{username}, em sẽ chọn #{choice}"
  end

  bot.command :trivia do |event|
    event.respond "Trả lời bằng dấu = phía trước anh chị nhé !"
    start_time = Time.now
    url = "https://opentdb.com/api.php?amount=1&difficulty=easy&type=multiple"
    response = RestClient.get url
    data = JSON.parse(response)
    data = data["results"].first
    category = data["category"]
    question = data["question"]
    choices = [].push(data["correct_answer"]).push(data["incorrect_answers"]).flatten.shuffle
    end_time = Time.now

    time = (end_time - start_time).round 2
    # event.respond "Mất #{time}s để lấy cái câu hỏi này về đấy !"
    choice_respond = ""
    choices.each_with_index do |choice, index|
      choice_respond << "#{index+1}. #{choice}\n"
    end

    question_respond = "Question: #{question}\n#{choice_respond}"
    message = event.respond question_respond

    event.user.await(:answer) do |answer_event|

      if answer_event.message.content.start_with? "="

        answer = answer_event.message.content.delete("=").to_i
        user = answer_event.user
        if choices[answer-1].eql? data["correct_answer"]
          DB.add_point(user)
          current_point = DB.get_point(user)

          respond = "<@#{user.id}> trả lời chính xác. Bạn đang có #{current_point}p."
          answer_event.respond respond
        else
          answer_event.respond "Vãi xoài !\nCâu trả nhời đúng nà: **#{data["correct_answer"]}**."
        end

      true

      else
        false
      end
    end

    nil
  end

  bot.command :disconnect do |event|
    channel = event.user.voice_channel
    next "You're not in any voice channel!" unless channel
    voice_bot = event.voice
    voice_bot.destroy
    nil
  end

  bot.command :tts do |event, *args|
    channel = event.user.voice_channel

    if channel
      bot.voice_connect(channel)
    else
      event.respond "You're not in any voice channel!"
      return
    end

    sentence = args.join(" ")
    voice_bot = event.voice
    start_t = Time.now
    id = SoundOfText.get_voice_id sentence
    url = SoundOfText.get_sound id
    end_t = Time.now
    time = (end_t - start_t).round 2
    puts url
    event.respond "Mất #{time}s mới sủa ra được câu hay như thế này đấy các cháu ạ"
    voice_bot.play_file(url)
    voice_bot.speaking=false unless voice_bot.playing?

    nil
  end

  # bot.command :cfs do |event, *args|
  #   sentence = args.join(" ")
  #   cfs_channel_id = 588263217042554891
  #   id = DB.add_confession sentence

  #   bot.send_message(cfs_channel_id, DB.get_confession(id))
  # end

  bot.command :ping do |event|
    message = DiscordHelper.embed_message event.channel, "🏓 Pong!"
    message.edit DiscordHelper.embed_message event.channel, "🏓 Pong! #{Time.now - event.timestamp} s"
  end

  bot.command :alert do |event, *args|
    event.message.react "🕒"
    time = args[0].to_i * 60
    sleep(time)
    event.respond "<@#{event.message.user.id}>, dậy đi bạn nhỏ ơi 🙃"
  end

  bot.command :creator do |event|
    next if event.user.id != 388659492071669760
    binding.pry
  end

  bot.run
end
