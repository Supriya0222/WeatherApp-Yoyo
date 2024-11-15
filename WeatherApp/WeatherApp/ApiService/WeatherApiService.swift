//
//  WeatherApiService.swift
//  WeatherApp
//
//  Created by Supriya on 13/11/2024.
//

import Foundation
import CoreLocation

protocol WeatherAPIServiceProtocol {
    func fetchCurrentWeather(for location: CLLocation) async throws -> CurrentWeatherModel
    func fetchForecast(for location: CLLocation) async throws -> ForecastModel
}

class WeatherAPIService: WeatherAPIServiceProtocol {
    
    func fetchCurrentWeather(for location: CLLocation) async throws -> CurrentWeatherModel {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let urlString = APIServiceConstant.RequestEndpoint.current.getUrl(latitude, longitude)
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
             throw URLError(.badServerResponse)
         }
        let weatherResponse = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
        return weatherResponse
    }
    
    
    func fetchForecast(for location: CLLocation) async throws -> ForecastModel {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let urlString = APIServiceConstant.RequestEndpoint.forecast.getUrl(latitude, longitude)
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let forecastResponse = try JSONDecoder().decode(ForecastModel.self, from: data)
        return forecastResponse
    }
}
