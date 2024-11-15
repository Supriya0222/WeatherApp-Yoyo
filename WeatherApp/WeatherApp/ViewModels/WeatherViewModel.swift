//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Supriya on 13/11/2024.
//

import Foundation
import Combine
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    
    @Published var currentWeather: CurrentWeatherModel?
    @Published var forecast: ForecastModel? {
        didSet {
        filteredForecasts = self.getFilteredForecasts()
        }
    }
    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showAlert: Bool = false
    @Published var filteredForecasts: [ForecastModel.ForecastInfo]?
    @Published var todaysForecast: [ForecastModel.ForecastInfo]?
    private var cancellables = Set<AnyCancellable>()



    var locationManager = LocationManager()
    
    let iconURL: String = APIServiceConstant.apiOpenWeatherIconBaseUrl
    
    var apiService: WeatherAPIServiceProtocol
    
    init(apiService: WeatherAPIService = WeatherAPIService(), locationManager: LocationManager = LocationManager()) {
        self.apiService = apiService
        
        self.locationManager = locationManager
        
        //Attempt to bug fixing; user has to exit app and open again for location to be obtained
        //Location object not triggered
        
        // Observe location updates
        locationManager.$userLocation
            .sink { [weak self] location in
                if let location = location {
                    // Fetch weather only once location is received
                    Task {
                        await self?.fetchWeatherData(for: location)
                    }

                }
            }
            .store(in: &cancellables)
        
        // Observe location authorization status
        locationManager.$locationAuthorizationStatus
            .sink { [weak self] status in
                if status == .authorizedWhenInUse || status == .authorizedAlways {
                    self?.locationManager.startLocationUpdates()
                }
            }
            .store(in: &cancellables)
         
    }
    
    // Method to trigger location fetch and weather update
    func fetchLocationAndWeather() {
        if let error = locationManager.checkLocationAuthorization() {
            self.showAlert = true
            self.errorMessage = error
            
        }
        
        if let location = locationManager.lastKnownLocation {
            Task {
                await fetchWeatherData(for: location)
            }
        }

    }
        
    func fetchWeatherData(for location: CLLocation) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Fetch current weather and forecast concurrently
            async let currentWeather = apiService.fetchCurrentWeather(for: location)
            async let forecast = apiService.fetchForecast(for: location)

            self.currentWeather = try await currentWeather
            self.forecast = try await forecast
        } catch {
            DispatchQueue.main.async {
                let isError = true
                if isError {
                    self.showAlert = true
                    self.errorMessage = .localized(.serverErrorMessage) + "\(error.localizedDescription)"
                }
            }
        }
        
        isLoading = false
    }
    
    // Conversion function
    func kelvinToCelsius(_ kelvin: Double) -> String {
        let celcius: Double = kelvin - 273
        return String(format: "%.1f", celcius)
    }
    
    func iconUrl(for icon: String) -> URL? {
        guard let url = URL(string: iconURL + "\(icon).png") else { return nil }
        return url
    }
    
    func rainProbability(_ rain: Double) -> String? {
        let probability: Double = rain * 100
        return probability == 0 ? nil : String(format: "%.0f", probability)
    }
    
    func requestLocationPermission() {
        locationManager.requestLocationPermission()
    }
    
    func getFilteredForecasts() -> [ForecastModel.ForecastInfo]? {
        guard let forecast = forecast else { return nil }
        // Sort the forecast list by the dt value (timestamp)
        let sortedForecasts = forecast.list.sorted { $0.dt < $1.dt }
        
        let calendar = Calendar.current
        
        // Group forecasts by day
        var groupedByDay: [Date: [ForecastModel.ForecastInfo]] = [:]
        for forecast in sortedForecasts {
            let forecastDate = Date(timeIntervalSince1970: forecast.dt)
            let dayStart = calendar.startOfDay(for: forecastDate)
            groupedByDay[dayStart, default: []].append(forecast)
        }
        
        var filteredForecasts: [ForecastModel.ForecastInfo] = []
        
        
        // Get the first day (all entries)
        if let firstDay = groupedByDay.keys.sorted().first {
            self.todaysForecast = groupedByDay[firstDay]
            
            // For the other days, append only the first entry
            for day in groupedByDay.keys.sorted() {
                if let firstEntry = groupedByDay[day]?.first {
                    filteredForecasts.append(firstEntry)
                }
            }
        }
        
        
        return filteredForecasts
    }

    
}
