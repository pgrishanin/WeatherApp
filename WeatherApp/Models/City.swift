//
//  City.swift
//  WeatherApp
//
//  Created by Pavel Grishanin on 13.11.2020.
//

import Foundation

struct City {
    let name: String
    let latitude: Double
    let longitude: Double
    let timezone: String
    
    static func cityList() -> [City] {
        [
            City(
                name: "London",
                latitude: 51.509865,
                longitude: -0.118092,
                timezone: "GMT+1"
            ),
            City(
                name: "Moscow",
                latitude: 55.751244,
                longitude: 37.618423,
                timezone: "GMT+3"
            ),
            City(
                name: "New York",
                latitude: 40.730610,
                longitude: -73.935242,
                timezone: "GMT-5"
            ),
        ]
    }
}
