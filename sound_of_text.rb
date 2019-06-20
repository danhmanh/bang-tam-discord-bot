module SoundOfText
  def self.get_voice_id text
    url = "https://api.soundoftext.com/sounds"
    payload = {
      "engine": "Google",
      "data": {
        "text": text,
        "voice": "vi-VN"
      }
    }.to_json
    response = RestClient.post url, payload, content_type: "application/json"
    data = JSON.parse(response)
    id = data["success"] ? data["id"] : nil
  end

  def self.get_sound id
    url = "https://api.soundoftext.com/sounds/#{id}"
    response = RestClient.get url
    data = JSON.parse(response)
    data["location"]
  end
end
