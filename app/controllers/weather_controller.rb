class WeatherController < ApplicationController
  def index
    location = Location.of Date.current 
    render json: Weather.for(location)
  end

  def sms
    location = Location.of Date.current 
    message = Weather.for(location)[0..150]
    blowerio = RestClient::Resource.new(ENV['BLOWERIO_URL'])
    response = blowerio['/messages'].post(:to => '+358405477215', :message => message )
    render text: response.code
  end
end