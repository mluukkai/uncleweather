class Weather
  def self.for(location)
     Weather.new(location[:lon], location[:lat]).get
  end

  def self.hourly_for(location)
     Weather.new(location[:lon], location[:lat]).get_hourly
  end

  def self.daily_for(location)
     Weather.new(location[:lon], location[:lat]).get_daily
  end

  def initialize(lon, lat)
    key = ENV['FORECA_KEY']
    @url = "http://apitest.foreca.net/?lon=#{lon}&lat=#{lat}&key=#{key}&format=json"
  end

  def get
    resp = HTTParty.get(@url)
    parse JSON.parse(resp.parsed_response)
  end

  def get_daily
    resp = HTTParty.get(@url)
    daily(JSON.parse(resp.parsed_response)['fcd'])
  end

  def get_hourly
    resp = HTTParty.get(@url)
    hourly(JSON.parse(resp.parsed_response)['fch'])
  end

  def parse(hash)
    h = hourly(hash['fch'])
    d = daily(hash['fcd'])
    "#{h} #{d}"
  end

  def hourly(hours)
    hours = hours.map{ |h| hour(h) }[0..23]
    hour_strings = []
    0.upto(7).each do |i| 
      hour_strings << hours_average(hours[i*3, 3])
    end
    hour_strings.join(' ')
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
    weather = hash['s']
    precipitation = hash['p']
    "#{wday(date.wday)}: #{min} #{max} #{wind_d}#{wind} #{precipitation}"
  end

  def hour(hash)
    time = Time.parse(hash['dt'])
    {
      hour: time.hour,
      day: time.day,
      t: hash['t'],
      ws: hash['ws'],
      wn: hash['wn'],
      p: hash['p']
    }
  end

  def hours_average(hours)
    from = hours.first[:hour]
    to = hours.last[:hour]+1
    temps = hours.map{ |h| h[:t] }
    ws = hours.map{ |h| h[:ws] }.max
    wd = hours.map{ |h| h[:wn] }[1]
    p = hours.map{ |h| h[:p] }.sum
    "#{from}-#{to}: #{temps.min} #{temps.max} #{wd}#{ws} #{p}"
  end

  def to_s(weather)
    clouds = weather[1]
    precipitation = weather[2].to_i
    type = weather[3].to_i
    return "" if precipitation==0
    return "lumi" if precipitation<3
    "paljon lunta"
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