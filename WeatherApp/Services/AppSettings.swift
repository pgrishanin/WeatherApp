//
//  AppSettings.swift
//  WeatherApp
//
//  Created by Pavel Grishanin on 13.11.2020.
//

import UIKit
import MapKit

enum DayTime {
    case day
    case evening
    case night
    case morning
}

class AppSettingsService {
    static let shared = AppSettingsService()
    
    private init() {}
    
    public func getSkyColors(byHour: Int) -> UIColor {
        
        switch byHour {
        case 20...24:
            return UIColor(red: 0.168, green: 0.184, blue: 0.466, alpha: 1)
        case 0...5:
            return UIColor(red: 0.168, green: 0.184, blue: 0.466, alpha: 1)
        case 6...8:
            return UIColor(red: 0.682, green: 0.929, blue: 1, alpha: 1)
        case 17...19:
            return UIColor(red: 0.521, green: 0.349, blue: 0.533, alpha: 1)
        default:
            return UIColor(red: 0, green: 0.741, blue: 0.996, alpha: 1)
        }
    }
}
