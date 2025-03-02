require 'csv'
require 'json'
require 'open-uri'
require 'uri'

API_SERVER = 'http://localhost:3000/geocode'

CSV.new($stdin, headers: true).each {|r|
  city = r['発生区市町村']
  place = r['発生場所']
  next if city.nil? or place.nil?
  address = r['発生区市町村'] + r['発生場所']
  url = "#{API_SERVER}?format=ndgeojson&address=" + 
    "#{URI.encode_www_form_component(address)}"
  f = JSON.parse(URI.open(url).read)
  f['properties'] = {
    :address => f['properties']['output'],
    :gender => r['被害者性別']
  }
  print "#{JSON.dump(f)}\n"
}

