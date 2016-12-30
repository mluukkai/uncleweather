class Location
  def self.of(date)
    locations = {
      '2' => { lon: 28.421936, lat: 68.370696 }, 
      '3' => { lon: 28.258514, lat: 68.319005 },  
      '4' => { lon: 28.082812, lat: 68.220373 }, 
      '5' => { lon: 27.753909, lat: 68.216169 },  
      '6' => { lon: 27.616580, lat: 68.313810 },  
      '7' => { lon: 27.435477, lat: 68.417760 }, 
      '8' => { lon: 27.435477, lat: 68.417760 }, 
      '9' => { lon: 27.435477, lat: 68.417760 }  
    }
    locations.default = { lon: 28.4668, lat: 68.4761 } 

    locations[date.day.to_s]
  end
end