class Message
  def self.numbers
    {
      eno: ENV['ENO'],
      mluukkai: ENV['MLUUKKAI']
    }
  end

  def self.to(whom)
    location = Location.of Date.current 
    hourly = Weather.hourly_for(location)[0..158]
    daily = Weather.daily_for(location)[0..158]

    phone = numbers[whom]

    raise "number not known" if phone.nil?

    codes = []

    blowerio = RestClient::Resource.new(ENV['BLOWERIO_URL'])
    response = blowerio['/messages'].post(:to => phone, :message => hourly )
    codes << response.code
    #response = blowerio['/messages'].post(:to => phone, :message => daily )
    #codes << response.code
    
    codes
  end
end