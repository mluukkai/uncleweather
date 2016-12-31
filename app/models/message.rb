class Message
  def self.numbers
    {
      eno: ENV['ENO'],
      mluukkai: ENV['MLUUKKAI']
    }
  end

  def self.to(whom)
    location = Location.of Date.current 
    today = Weather.today_for(location)[0..158]
    tomorrow = Weather.tomorrow_for(location)[0..158]
    week = Weather.week_for(location)[0..158]

    phone = numbers[whom]

    raise "number not known" if phone.nil?

    codes = []

    blowerio = RestClient::Resource.new(ENV['BLOWERIO_URL'])
    response = blowerio['/messages'].post(:to => phone, :message => today )
    codes << response.code
    response = blowerio['/messages'].post(:to => phone, :message => tomorrow )  
    codes << response.code
    response = blowerio['/messages'].post(:to => phone, :message => week )
    codes << response.code
    
    codes
  end
end