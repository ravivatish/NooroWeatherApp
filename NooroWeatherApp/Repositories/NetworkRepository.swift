//
//  NetworkRepository.swift
//  NooroWeatherApp
//
//  Created by ravinder vatish on 12/17/24.
//

import Foundation

protocol NetworkRepositoryInterface {
    
    func getCityWeather(_ cityName: String) async  -> Result<WeatherData, NetworkErrors>
}
class NetworkRepository: NetworkRepositoryInterface {
    
    private let apiKey = "69af1a4fab754f75ad8222947241712"
    func getCityWeather(_ cityName: String) async -> Result<WeatherData, NetworkErrors> {
        guard let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(cityName)&aqi=no") else {
            return .failure(.invalidURL)
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // HTTP response check
            guard let httpResponse = response as? HTTPURLResponse, 200...299  ~= httpResponse.statusCode else {
                print(response)
               
                return .failure(.requestFailed)
            }
            print(String(data: data, encoding: .utf8) ?? "")
            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            return .success(weatherData)
            
        } catch let error as DecodingError {
            print(error)
            return .failure(.decodingFailed)
        } catch {
            print(error)
            return .failure(.unknownError(error))
        }
    }
}
