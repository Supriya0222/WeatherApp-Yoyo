//
//  ActivityIndicator.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 14/11/2024.
//

import SwiftUI
import UIKit

// Create a SwiftUI wrapper for the UIActivityIndicatorView
struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    var style: UIActivityIndicatorView.Style = .large

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true // Hide when not animating
        return activityIndicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
    
}
