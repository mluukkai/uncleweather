class Message
  def self.numbers
    {
      eno: ENV['ENO'],
      mluukkai: ENV['MLUUKKAI']
    }
  end

  def self.to(whom)
    location = Location.of Date.current 
    hourly = Weather.hourly_for(location)[0..150]
    daily = Weather.daily_for(location)[0..150]

    phone = numbers[whom]

    raise "number not known" if phone.nil?

    codes = []

    puts "message to #{phone} #{ENV['BLOWERIO_URL']}"
    puts "#{hourly.length} #{daily.length}"

    blowerio = RestClient::Resource.new(ENV['BLOWERIO_URL'])
    response = blowerio['/messages'].post :to => '+358405477215', :message => hourly
    puts response.body

    blowerio = RestClient::Resource.new(ENV['BLOWERIO_URL'])
    response = blowerio['/messages'].post(:to => phone, :message => hourly )
    puts response.body
    codes << response.code
    response = blowerio['/messages'].post(:to => phone, :message => daily )
    codes << response.code
    
    codes
  end
end