class WeatherController < ApplicationController
  def index
    location = Location.of Date.current 
    hourly = Weather.today_for(location)[0..158]
    tomorrow = Weather.tomorrow_for(location)[0..158]
    daily = Weather.week_for(location)[0..158]

    render json: "#{hourly}\n#{tomorrow}\n#{daily}"
  end

  def sms
    responses = Message.to(:mluukkai)
    render json: responses
  end

  def info
    locations = {}

    d = Date.parse('2016-12-31')
    locations[d.to_s] = Location.of(d)

    1.upto(12) do |i|
      d = Date.parse("2017-1-#{i}")
      locations[d.to_s] = Location.of(d)
    end
     
    render json: locations
  end
end