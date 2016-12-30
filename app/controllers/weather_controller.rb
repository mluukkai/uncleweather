class WeatherController < ApplicationController
  def index
    location = Location.of Date.current 
    render json: Weather.for(location)
  end

  def sms
    responses = { error: "not available" } #Message.to(:mluukkai)
    render json: responses
  end
end