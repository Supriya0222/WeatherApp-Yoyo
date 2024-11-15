//
//  AlertView.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 14/11/2024.
//

import SwiftUI
import UIKit

struct AlertViewController: UIViewControllerRepresentable {
    let title: String
    let message: String
    let dismissButtonTitle: String

    @Binding var isPresented: Bool

    // The makeCoordinator function is required
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    // Create the UIAlertController
    func makeUIViewController(context: Context) -> UIViewController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: dismissButtonTitle, style: .default, handler: { _ in
            self.isPresented = false // Dismiss alert when button is tapped
        }))
        
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear // Ensures the alert works with SwiftUI's view hierarchy
        return viewController
    }

    // Update the UIViewController (this will show the alert)
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            if uiViewController.presentedViewController == nil {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: dismissButtonTitle, style: .default, handler: { _ in
                    self.isPresented = false // Dismiss alert when button is tapped
                }))
                uiViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
}

class Coordinator: NSObject {
    var parent: AlertViewController

    init(parent: AlertViewController) {
        self.parent = parent
    }

    func dismissAlert() {
        parent.isPresented = false
    }
}

