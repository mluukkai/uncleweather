class Weather
  def self.today_for(location)
     Weather.new(location[:lon], location[:lat]).get_hourly
  end

  def self.tomorrow_for(location)
     Weather.new(location[:lon], location[:lat]).get_hourly_tomorrow
  end

  def self.week_for(location)
     Weather.new(location[:lon], location[:lat]).get_daily
  end

  def initialize(lon, lat)
    key = ENV['FORECA_KEY']
    @url = "http://apitest.foreca.net/?lon=#{lon}&lat=#{lat}&key=#{key}&format=json"
  end

  def get_daily
    resp = HTTParty.get(@url)
    daily(JSON.parse(resp.parsed_response)['fcd'])
  end

  def get_hourly
    resp = HTTParty.get(@url)
    hourly_today(JSON.parse(resp.parsed_response)['fch'])
  end

  def get_hourly_tomorrow
    resp = HTTParty.get(@url)
    hourly = hourly_tomorrow(JSON.parse(resp.parsed_response)['fch'])
    date = wday(Time.now.wday+1) 
    "#{date}: #{hourly}"
  end

  def hourly_today(hours)
    hourly(hours, 0, 3)
  end

  def hourly_tomorrow(hours)
    hourly(hours, 24, 4)
  end

  def hourly(hours, starts, gran)
    to = 24/gran-1
    ends = starts+23 

    hours = hours.map{ |h| hour(h) }[starts..ends]
    hour_strings = []
    0.upto(to).each do |i| 
      hour_strings << hours_average(hours[i*gran, gran])
    end
    hour_strings.join(' ')
  end

  def daily(days)
    days[2..7].map{ |d| day(d) }.join(' ')
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
    p = hours.map{ |h| h[:p] }.sum.round(1)
    "#{from}-#{to}: #{temps.min} #{temps.max} #{wd}#{ws} #{p}"
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