class WeatherController < ApplicationController
  def index
    location = Location.of Date.current 
    render json: Weather.for(location)
  end

  def sms
    client = EasySMS::Client.new
    resp = client.messages.create(to: '+358405477215', body: 'Hello from Easy SMS Add-on for Heroku.')
    render text: resp.inspect
  end
end