//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Supriya on 13/11/2024.
//

import Foundation

struct ForecastModel: Codable {
    let list: [ForecastInfo]
    let city: City
    
    struct City: Codable, Identifiable {
        let id: Int
        let sunrise: Double 
        let sunset: Double
        let name: String
    }
    
    struct ForecastInfo: Codable, Identifiable {
        var id : String { dt_txt }
        let dt_txt: String
        let dt: Double
        let main: CurrentDetails
        let weather: [WeatherCondition]
        let pop: Double

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

    }
    

}
