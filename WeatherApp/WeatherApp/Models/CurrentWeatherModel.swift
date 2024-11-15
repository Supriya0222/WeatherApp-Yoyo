//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by Supriya on 13/11/2024.
//

import Foundation

// MARK: - Current Weather
struct CurrentWeatherModel: Codable {
    let name: String
    let main: CurrentDetails
    let weather: [WeatherCondition]
    let sys: OtherDetails
    
    struct CurrentDetails: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double

    }
    
    struct WeatherCondition: Codable {
        let main: String
        let description: String
        let icon: String
    }
    
    struct OtherDetails: Codable {
        let type: Int
        let country: String
        let sunrise: Double
        let sunset: Double
    }
    
    
}
