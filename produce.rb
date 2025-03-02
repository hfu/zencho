require 'csv'
require 'json'
require 'open-uri'
require 'uri'

API_SERVER = 'http://localhost:3000/geocode'

CSV.new($stdin, headers: true).each {|r|
  city = r['発生区市町村']
  place = r['発生場所']
  next if city.nil? or place.nil?
  address = "東京都#{r['発生区市町村']}#{r['発生場所']}"
  url = "#{API_SERVER}?format=ndgeojson&address=" + 
    "#{URI.encode_www_form_component(address)}"
  f = JSON.parse(URI.open(url).read)
  f['geometry']['coordinates'].map! {|v| v + rand * 0.005}
  f['properties'] = {
    :address => f['properties']['output'],
    :被害者性別 => r['被害者性別'],
    :発生曜日 => r['発生曜日'],
    :発生時 => r['発生時'],
    :被害者年代 => r['被害者年代'],
    :被害者学職別 => r['被害者学職別'],
    :被疑者の交通手段 => r['被疑者の交通手段'],
    :事案名 => r['事案名'],
    'marker-color' => r['被害者性別'] == '女' ? '#ff0' : 
      r['被害者性別'] == '男' ? '#0ff' : '#888'
  }
  print "#{JSON.dump(f)}\n"
}

