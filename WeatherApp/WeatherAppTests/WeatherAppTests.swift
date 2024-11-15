//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Supriya on 13/11/2024.
//

import XCTest
import CoreLocation
@testable import WeatherApp

protocol LocationService {
    func getLocation() async throws -> CLLocation
}

class MockWeatherAPIService: WeatherAPIService {
    var mockWeather: CurrentWeatherModel?
    var shouldThrowError = false
    
    override func fetchCurrentWeather(for location: CLLocation) async throws -> CurrentWeatherModel {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        
        return mockWeather ?? CurrentWeatherModel(name: "Mock City", main: CurrentWeatherModel.CurrentDetails(temp: 20, temp_min: 1000, temp_max: 2000), weather: [CurrentWeatherModel.WeatherCondition(main: "Clouds", description: "Cloudy", icon: "04d")], sys: CurrentWeatherModel.OtherDetails(type: 1, country: "Mock Country", sunrise: 1000, sunset: 2000) )
    }
}

class MockLocationManager: LocationService {
    var mockLocation: CLLocation?
    var shouldThrowError = false
    
    func getLocation() async throws -> CLLocation {
        if shouldThrowError {
            throw NSError(domain: "LocationError", code: 1, userInfo: nil)
        }
        return mockLocation ?? CLLocation(latitude: 35.6895, longitude: 139.6917) // Mock location (Tokyo)
    }
}


class WeatherServiceFactory {
    @MainActor static func createWeatherViewModel() -> WeatherViewModel {
        let apiService = WeatherAPIService()  // You can also mock this API service similarly
        let locationManager = LocationManager()  // Default to real LocationManager
        
        return WeatherViewModel(apiService: apiService, locationManager: locationManager)
    }
}



final class WeatherAppTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherAPIService!
    var mockLocationManager: MockLocationManager!

    @MainActor override func setUp() {
        super.setUp()

        // Initialize mocks
        mockWeatherService = MockWeatherAPIService()
        mockLocationManager = MockLocationManager()

        viewModel = WeatherServiceFactory.createWeatherViewModel()
    }

    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        mockLocationManager = nil
        super.tearDown()
    }
    
    @MainActor func testFetchWeather_Success() async {
        // Given: A mock weather object and location
        mockWeatherService.mockWeather = CurrentWeatherModel(name: "Tokyo", main: CurrentWeatherModel.CurrentDetails(temp: 284.2, temp_min: 283.06, temp_max: 286.82), weather: [CurrentWeatherModel.WeatherCondition(main: "Clouds", description: "Cloudy", icon: "04d")], sys: CurrentWeatherModel.OtherDetails(type: 1, country: "Japan", sunrise: 1726636384, sunset: 1726680975) )

        mockLocationManager.mockLocation = CLLocation(latitude: 35.6895, longitude: 139.6917) // Tokyo

        // When: Fetch weather data
        await viewModel.fetchWeatherData(for: mockLocationManager.mockLocation!)

        // Then: Verify that the ViewModel updates the temperature correctly
        XCTAssertEqual(viewModel.currentWeather?.main.temp, 284.2, "The temperature should be 284.2 Kelvin")
    }
    
    @MainActor func testKelvinToCelsiusConversion() {
        // Given: A known value in Kelvin
        let kelvinTemperature: Double = 284.2 // Freezing point of water in Kelvin
        let expectedCelsius = "11.1" // Freezing point of water in Celsius

        // When: We convert the Kelvin temperature to Celsius using the kelvinToCelsius function
        let celsiusTemperature = viewModel.kelvinToCelsius(kelvinTemperature)

        // Then: We verify that the result matches the expected Celsius value
        XCTAssertEqual(celsiusTemperature, expectedCelsius, "The kelvinToCelsius function did not return the expected result.")
    }



    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    


}
