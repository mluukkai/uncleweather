class Weather
  def initialize(lon, lat)
    lon = 28.4668
    lat = 68.4761
    @url = "http://apitest.foreca.net/?lon=#{lon}&lat=#{lat}&key=trsuGNYwg279VmPrSdwhbOCqnU&format=json"
  end

  def get
    resp = HTTParty.get(@url)
    parse JSON.parse(resp.parsed_response)
  end

  def parse(hash)
    #hourly hash['fch']
    daily hash['fcd']
  end

  def hourly(hours)
    hours.map{ |h| hour(h) }
  end

  def daily(days)
    days[1..7].map{ |d| day(d) }.join(' ')
  end  

  def day(hash)
    date = Date.parse hash['dt']
    max = hash['tx']
    min = hash['tn']
    wind = hash['ws']
    wind_d = hash['wn']
    "#{wday(date.wday)}: #{min} #{max} #{wind_d} #{wind}"
  end

  def hour(hash)
    
  end

  def wday(n)
    return "ma" if n==1
    return "ti" if n==2
    return "ke" if n==3
    return "to" if n==4
    return "pe" if n==5
    return "la" if n==6
    "su"
  end
end