//
//  Untitled.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 15/11/2024.
//

import SwiftUI

struct AsyncImageView: View {
    let url: URL
    @State private var imageData: Data?
    @State private var isLoading: Bool = true

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()  // Show loading indicator while image is being fetched
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }

            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        // Fetch image data asynchronously using URLSession
        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                self.imageData = data
                self.isLoading = false
            }
        }.resume()
    }
}
