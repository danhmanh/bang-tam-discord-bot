module DiscordHelper
  def self.embed_message channel, description, color = 0x66e35c
    channel.send_embed do |embed|
      embed.colour = color
      embed.description = description
      embed.timestamp = Time.at(Time.now.to_i)

      embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "made by rain with love 💕")
    end
  end
end
