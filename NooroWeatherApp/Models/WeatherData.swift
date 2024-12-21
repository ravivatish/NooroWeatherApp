//
//  WeatherData.swift
//  NooroWeatherApp
//
//  Created by ravinder vatish on 12/17/24.
//

import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: CurrentCityWeather
}

struct Location: Codable {
    let name: String
    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct CurrentCityWeather: Codable {
    private var _tempF: Double
    private var _humidity: Int
    private var _feelslikeF: Double
    private var _uv: Double
    
    // Custom initializer with default values
       init(tempF: Double = 0.0, humidity: Int = 0, feelslikeF: Double = 0.0, uv: Double = 0.0, condition: WeatherCondition = WeatherCondition(icon: "")) {
           self._tempF = tempF
           self._humidity = humidity
           self._feelslikeF = feelslikeF
           self._uv = uv
           self.condition = condition
       }
    
    var tempF: String {
        get { format(_tempF) }
        set {
            guard let value = Double(newValue) else {
                print("Invalid temperature value: \(newValue)")
                return
            }
            _tempF = value
        }
    }
    var humidity: String {
        get { String(_humidity) }
        set {
            guard let value = Int(newValue) else {
                print("Invalid humidity value: \(newValue)")
                return
            }
            _humidity = value
        }
    }
    var feelslikeF: String {
        get { format(_feelslikeF) }
        set {
            guard let value = Double(newValue) else {
                print("Invalid feels-like temperature value: \(newValue)")
                return
            }
            _feelslikeF = value
        }
    }
    var uv: String {
        get { format(_uv) }
        set {
            guard let value = Double(newValue) else {
                print("Invalid UV value: \(newValue)")
                return
            }
            _uv = value
        }
    }
    
    let condition: WeatherCondition
    
    enum CodingKeys: String, CodingKey {
        case _tempF = "temp_f"
        case _humidity = "humidity"
        case _feelslikeF = "feelslike_f"
        case _uv = "uv"
        case condition
    }
    
    // Helper method for consistent string formatting
    private func format(_ value: Double, precision: Int = 1) -> String {
        return String(format: "%.\(precision)f", value)
    }
}


struct WeatherCondition: Codable {
    let icon: String
}
