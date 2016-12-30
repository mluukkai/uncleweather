class WeatherController < ApplicationController
  def index
    location = Location.of Date.current 
    render json: Weather.for(location)
  end

  def sms
    location = Location.of Date.current 
    blowerio = RestClient::Resource.new(ENV['BLOWERIO_URL'])
    response = blowerio['/messages'].post(:to => '+358405477215', :message => Weather.for(location) )
    render text: response.code
  end
end