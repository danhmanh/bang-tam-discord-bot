module WeatherAPI
  WEATHER_APP_ID = "6cd7c6a5bef40e5fe47d5ff6d14a97b9"

  def self.get_weather name, coords
    url = "https://api.openweathermap.org/data/2.5/weather?lat=#{coords['lat']}&lon=#{coords['long']}&APPID=#{WEATHER_APP_ID}&units=metric&lang=vi"
    response = RestClient.get url
    data = JSON.parse response
    description = data["weather"][0]["description"]
    temp = data["main"]["temp"]
    message = "#{name} ngày hôm nay #{description}, nhiệt độ ngoài trời #{temp} độ C."
  end

  def self.get_coords response
    response["entities"]["location"].first["resolved"]["values"].first["coords"]
  end

  def self.get_name response
    response["entities"]["location"][0]["value"]
  end

  def self.get_message response
    coords = WeatherAPI.get_coords(response)
    name = WeatherAPI.get_name(response)
    message = WeatherAPI.get_weather name, coords
  end

end
