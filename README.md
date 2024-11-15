# WeatherApp-Yoyo
This is a SwiftUI-based iOS app that retrieves current weather data and weather forecasts for the next few days using the OpenWeatherMap API. The app allows users to obtain weather information by using their device's current location. It provides key weather details like temperature, as well as a 5-day weather forecast.

## Features
- API requests are based on the device's current geolocation.
- Using that location, Open Weather Map API has been used to get and display some weather data for today and the next 5 days.
- Modern UI: Built using SwiftUI, providing a clean and responsive user interface.
- Error Handling: Handles network errors and invalid city searches with user-friendly error messages.

## Requirements
- Xcode: Version 12.0 or later.
- iOS: Target iOS 14.0 or later.
- Programming Language: Swift 5.0+.
- API: OpenWeatherMap API KEY (free tier available for up to 60 requests per minute)

## Built With
Design pattern: MVVM
Language: Swift 5
UI: SwiftUI
API: URLSession
Vanilla iOS development

## Screenshots
![Simulator Screen Shot - iPhone 14 - 2024-11-15 at 20 42 06](https://github.com/user-attachments/assets/c330910b-a3f5-4bda-945e-84a1cc48760e)

![Simulator Screen Shot - iPhone 14 - 2024-11-15 at 20 42 19](https://github.com/user-attachments/assets/652b5cc5-4053-4a46-9bfc-2101eb5dfa59)

![Simulator Screen Shot - iPhone 14 - 2024-11-15 at 20 42 10](https://github.com/user-attachments/assets/8112d367-c69e-4f16-b8f9-cb9fac9bfe9c)

## Steps configure the API key and run the project locally
- Sign Up at OpenWeatherMap.
- Get your API Key and insert it into the app.
-  **Create the `ConfigSecret.xcconfig` File**: - In the root directory of the project, create a new file named `ConfigSecret.xcconfig`.
- Add the following line to store your API key: ```plaintext API_KEY = "your_api_key_here" ``` - Replace `"your_api_key_here"` with your actual API key from the weather service (or other API you are using).
- **Run the Project**: - After creating the `ConfigSecret.xcconfig` file, you should be able to run the app and the API key will be automatically accessed via the `Info.plist` and used for making network requests.

## Improvements
- Add more UnitTests
- Improve UI for better user interactions
- Handle offline mode
  



  


  


