//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Supriya on 13/11/2024.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WeatherListView()

        }
    }
}


