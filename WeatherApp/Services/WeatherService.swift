//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Pavel Grishanin on 13.11.2020.
//

import Foundation

class WeatherService {
    static let shared = WeatherService()
    
    private let weatherAPIUrl = "https://gridforecast.com/api/v1/forecast/%f;%f/202011131200?api_token=N4KOKDvJDHoeH2u7"
    
    private init() {}
    
    public func fetchWeather(
        latitude: Double,
        longitude: Double,
        closure: @escaping (_: Weather) -> Void,
        onError: @escaping (_: Error) -> Void
    ) -> Void {
        guard let url = URL(string: String(format: weatherAPIUrl, latitude, longitude)) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                closure(weather)
            } catch let error {
                onError(error)
            }
            
        }.resume()
    }
    
}
