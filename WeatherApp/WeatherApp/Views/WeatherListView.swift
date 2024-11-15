//
//  WeatherListView.swift
//  WeatherApp
//
//  Created by Supriya on 13/11/2024.
//

import Foundation
import SwiftUI

struct WeatherListView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("backgroundImage") // Found in Assets
                    .resizable()
                    .scaledToFill()  
                    .edgesIgnoringSafeArea(.all)
                VStack {
                
                    if viewModel.isLoading {
                        ActivityIndicator(isAnimating: $viewModel.isLoading)
                            .frame(width: 50, height: 50)
                    } else if viewModel.showAlert {
                        AlertViewController(
                            title: .localized(.errorTitle),
                            message: viewModel.errorMessage ?? "",
                            dismissButtonTitle: "OK",
                            isPresented: $viewModel.showAlert
                        )
                        .frame(width: 0, height: 0)
                    } else {
                        // Show current weather data
                        if let currentWeather = viewModel.currentWeather {
                            VStack(alignment: .center) {
                                Text(currentWeather.name)
                                    .padding(.top, 50)
                                    .font(.title)
                                    .foregroundColor(StyleGuide.primaryTextColor)
                                    .multilineTextAlignment(.center)
                                Text(viewModel.kelvinToCelsius(currentWeather.main.temp) + "°")
                                    .foregroundColor(StyleGuide.primaryTextColor)
                                    .font(.largeTitle)
                                Text(currentWeather.weather.first?.main ?? "")
                                    .foregroundColor(StyleGuide.primaryTextColor)
                                    .font(.title2)
                                HStack {
                                    Text("H:\(viewModel.kelvinToCelsius(currentWeather.main.temp_max))°")
                                        .foregroundColor(StyleGuide.primaryTextColor)
                                        .font(.title2)
                                        .padding()
                                    
                                    Text("L:\(viewModel.kelvinToCelsius(currentWeather.main.temp_min))°")
                                        .foregroundColor(StyleGuide.primaryTextColor)
                                        .font(.title2)
                                        .padding()
                                }
                                Divider()
                                Spacer() // Pushes the content to the top

                            }
                            .padding()
                            
                        }
                        
                        // Show today's details view
                        if let todaysDetails = viewModel.todaysForecast {
                            ScrollView(.horizontal, showsIndicators: true) {
                                
                                HStack (){
                                    ForEach(todaysDetails) { day in
                                        VStack {
                                            Text("\(getTime(from: day.dt))")
                                                .foregroundColor(StyleGuide.primaryTextColor)
                                            AsyncImageView(url: viewModel.iconUrl(for: day.weather.first?.icon ?? "")!)
                                                .scaledToFill()
                                                .frame(width: 30, height: 30)
                                            Text("\(viewModel.kelvinToCelsius(day.main.temp) + "°")")
                                                .foregroundColor(StyleGuide.primaryTextColor)
                                        }
                                        .frame(width: 50)
                                    }
                                    .padding(.horizontal, 8)
                                }
                                .padding(.bottom, 24)
                            }
                        }
                        // Show 10-day forecast
                        if let forecast = viewModel.forecast {
                            HStack {
                                Image("calenderIcon") // Found in Assets
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 20, height: 20)
                                
                                Text("10_day_forecast")
                                    .font(.headline)
                                    .foregroundColor(StyleGuide.primaryTextColor)
                            }
                            .padding(.vertical)
                            
                            if let filteredForecasts = viewModel.filteredForecasts {
                                List(filteredForecasts) { day in
                                    HStack() {
                                        Text(isToday(from: day.dt) ? .localized(.today) : "\(getDayOfWeek(from: day.dt))")
                                            .foregroundColor(StyleGuide.primaryTextColor)
                                            .frame(maxWidth: 50)
                                        
                                        if let prob = viewModel.rainProbability(day.pop) {
                                            VStack {
                                                AsyncImageView(url: viewModel.iconUrl(for: day.weather.first?.icon ?? "")!)
                                                    .scaledToFill()
                                                    .frame(width: 30, height: 30)
                                                Text("\(prob)%")
                                                    .foregroundColor(StyleGuide.blueTextColor)
                                            }
                                            .padding(.leading, 8)
                                        } else {
                                            AsyncImageView(url: viewModel.iconUrl(for: day.weather.first?.icon ?? "")!)
                                                .scaledToFill()
                                                .frame(width: 30, height: 30)
                                                .padding(.leading, 16)

                                        }

                                        HStack() {
                                            Text("\(viewModel.kelvinToCelsius(day.main.temp_min) + "°")")
                                                .foregroundColor(StyleGuide.primaryTextColor)
                                                .opacity(0.3)
                                            Rectangle()
                                                .fill(StyleGuide.primaryTextColor)
                                                .opacity(0.5)
                                                .frame(width: 60)
                                                .frame(height: 2)
                                                .padding(.vertical, 5)
                                            Text("\(viewModel.kelvinToCelsius(day.main.temp_max) + "°")")
                                                .foregroundColor(StyleGuide.primaryTextColor)
                                        }
                                        .padding(.leading, 20)
                                        .frame(maxWidth: .infinity)
                                        
                                    }
                                    
                                    .padding(.top, 8)
                                    .listRowBackground(Color.clear)
                                    .frame(height: 50)

                                }
                                .modifier(ListBackgroundModifier())
                            }
                        }
                    }
                }
                .onAppear {
                    
                    viewModel.fetchLocationAndWeather()
                }
            }

        }
    }
}

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}

struct ListBackgroundModifier: ViewModifier {

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

