//
//  DateUtility.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 14/11/2024.
//

import Foundation
import UIKit


public func getDayOfWeek(from timestamp: Double) -> String {
    
    let date = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    // Set the date style to "none" since we only want the weekday
    dateFormatter.dateFormat = "EEE"
    
    return dateFormatter.string(from: date)
}

public func getTime(from timestamp: Double) -> String {
    
    let date = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    return dateFormatter.string(from: date)
}

public func isToday(from timestamp: Double) -> Bool {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let date = Date(timeIntervalSince1970: timestamp)
    let calendar = Calendar.current
    
    return calendar.isDateInToday(date)
}

