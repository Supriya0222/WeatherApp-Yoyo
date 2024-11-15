//
//  Localizable.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 15/11/2024.
//

import Foundation

struct Localizable {
    fileprivate let contents: String
    
    init(_ contents: String) {
        self.contents = contents
    }
}

extension String {
    // Returns a localized string.
    static func localized(_ key: Localizable) -> String {
        return key.contents
    }
}

extension Localizable{
    static let errorTitle = Localizable(NSLocalizedString("error.title", comment: ""))
    static let today = Localizable(NSLocalizedString("today", comment: ""))
    static let permissionsDeniedMessage = Localizable(NSLocalizedString("locations_permissions_denied", comment: ""))
    static let serverErrorMessage = Localizable(NSLocalizedString("server_error", comment: ""))

}
