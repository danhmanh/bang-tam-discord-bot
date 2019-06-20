module WitAPI
  APP_ID = 2071223439671663
  ACCESS_TOKEN = "NRLXPRIKE54FH66PFLVQQMEN37D2F5XP"

  $client = Wit.new(access_token: ACCESS_TOKEN)

  def self.send_message message
    rsp = $client.message(message)
  end

end

# rsp = client.message("thời tiết Tokyo")
# puts("Yay, got Wit.ai response: #{rsp}")
# coords = get_coords(rsp)
# name = get_name(rsp)

# puts parse_weather_response name, coords["lat"], coords["long"]

# {"_text"=>"thời tiết Hà Nội",
#   "entities"=>
#    {"weather"=>[{"confidence"=>0.96788527027406, "value"=>"thời tiết", "type"=>"value"}],
#     "location"=>
#      [{"confidence"=>0.932905,
#        "value"=>"Hà Nội",
#        "resolved"=>
#         {"values"=>
#           [{"name"=>"Hanoi",
#             "grain"=>"locality",
#             "type"=>"resolved",
#             "timezone"=>"Asia/Ho_Chi_Minh",
#             "coords"=>{"lat"=>21.024499893188, "long"=>105.84117126465},
#             "external"=>
#              {"geonames"=>"1581130", "wikidata"=>"Q1858", "wikipedia"=>"Hanoi"}}]}}]},
#   "msg_id"=>"16BwvZb7DwtD6yhsM"}



# conf = rsp["entities"]["weather"].first["confidence"]
# rsp["entities"]["location"].first["resolved"]["values"].first["coords"]

# user = User.find 17

# 10.times do
#   p = user.places.create(
#     name: Faker::ProgrammingLanguage.unique.name,
#     category_id: 1,
#     caption: "Caption here",
#     long: 105.7839475,
#     lat: 21.02006,
#     active: true,
#     address: Faker::Address.street_address,
#     attachment_attributes: {
#       url: "https://capitri-develop.s3.ap-southeast-1.amazonaws.com/201905241014470000/05-14-305106637387157345071.mp4",
#       thumb_url: "https://capitri-develop.s3.ap-southeast-1.amazonaws.com/201905241014470000/thumb-3751d45b-19a9-48af-a5a0-38491b1fa0e9.jpeg",
#       width: 720.0,
#       height: 1280.0
#     }
#   )
# end



# 10.times do
#   user.check_ins.create(
#     place_id: 96,
#     story: Faker::Lorem.sentence(3),
#     public: true,
#     star: 5,
#     budget: 20,
#     attachment_attributes: {
# url:
# "https://capitri-develop.s3.ap-southeast-1.amazonaws.com/201905241014470000/05-14-305106637387157345071.mp4",
# thumb_url:
# "https://capitri-develop.s3.ap-southeast-1.amazonaws.com/201905241014470000/thumb-3751d45b-19a9-48af-a5a0-38491b1fa0e9.jpeg",
#       width: 720.0,
#       height: 1280.0
#     }
#   )
# end



# url:
# "https://capitri-develop.s3.ap-southeast-1.amazonaws.com/201905241014470000/05-14-305106637387157345071.mp4",
# thumb_url:
# "https://capitri-develop.s3.ap-southeast-1.amazonaws.com/201905241014470000/thumb-3751d45b-19a9-48af-a5a0-38491b1fa0e9.jpeg",

