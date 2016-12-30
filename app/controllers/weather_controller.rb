class WeatherController < ApplicationController
  def index
    w = Weather.new(1,1)

    render json: w.get
  end
end