class WeatherController < ApplicationController
  def index
    location = Location.of Date.current 
    render json: Weather.for(location)
  end

  def sms
    location = Location.of Date.current 
    hourly = Weather.hourly_for(location)[0..150]
    daily = Weather.daily_for(location)[0..150]
    mluukkai = '+358405477215'
    eno = '+358505377055'
    phone = mluukkai

    blowerio = RestClient::Resource.new(ENV['BLOWERIO_URL'])
    response1 = blowerio['/messages'].post(:to => phone, :message => hourly )
    response2 = blowerio['/messages'].post(:to => phone, :message => daily )

    render json: [ response1.code, response2.code }
  end
end