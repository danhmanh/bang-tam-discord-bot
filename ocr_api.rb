module OcrAPI

  def self.parse_image img_url
    url = "https://api.ocr.space/parse/image"
    payload = {
        "apikey": "a18804cf8088957",
        "url": img_url
    }
    response = RestClient.post url, payload, content_type: "application/json"
    data = JSON.parse(response)
    return nil if data["OCRExitCode"] != 1
    math_str = data["ParsedResults"].first["ParsedText"].delete("=").strip
  end

end
