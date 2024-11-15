//
//  Untitled.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 15/11/2024.
//

import Foundation

public struct APIServiceConstant {
    // Note: Base URL and APP ID should ideally be in a git-ignored config file, where the values can also be set using environment variables (for App Center builds for example).
    // This token is for trial and will be deactivated after the code review is done.
    
    static let apiOpenWeatherMapAppId = "ad5ca998961f5a73c2a23cf0bd2aa311"
    static let apiOpenWeatherIconBaseUrl = "https://openweathermap.org/img/wn/"
    static let baseUrl = "https://api.openweathermap.org"
    
    public enum RequestEndpoint {
        case current
        case forecast
        
        func getUrl(_ latitude: Double, _ longitude: Double) -> String {
            switch self {
                case .current:
                    return "\(baseUrl)/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiOpenWeatherMapAppId)"
                case .forecast:
                    return "\(baseUrl)/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiOpenWeatherMapAppId)"
            }
        }
    }
}
