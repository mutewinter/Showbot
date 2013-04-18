require 'uri'
require 'net/http'

SHOUTCAST_URI = URI("http://5by5.fm/")
HEADERS = {
  "Icy-MetaData" => '1'
}


# Fetches the show title from the live stream defined by URI
def fetch_show
  @last_update = Time.now

  http = Net::HTTP.new(SHOUTCAST_URI.host, SHOUTCAST_URI.port)


  chunk_count = 0
  chunk_limit = 20 # Limit chunks to prevent lockups
  http.get(SHOUTCAST_URI.path, HEADERS) do |chunk|
    chunk_count += 1
    if chunk =~ /StreamTitle='(.+?)';/
      p chunk
      return $1
      break;
    elsif chunk_count > chunk_limit
      return nil
    end
  end
end

puts fetch_show
