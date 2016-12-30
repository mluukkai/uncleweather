class WeatherController < ApplicationController
  def index
    location = Location.of Date.current 
    render json: Weather.for(location)
  end

  def sms
    blowerio = RestClient::Resource.new(ENV['BLOWERIO_URL'])
    response = blowerio['/messages'].post(:to => '+358405477215', :message => 'Hello from Blower.io')
    render text: response.code
  end
end