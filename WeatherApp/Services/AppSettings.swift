//
//  AppSettings.swift
//  WeatherApp
//
//  Created by Pavel Grishanin on 13.11.2020.
//

import UIKit

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
            return UIColor(red: 43/255, green: 47/255, blue: 119/255, alpha: 1)
        case 0...5:
            return UIColor(red: 43/255, green: 47/255, blue: 119/255, alpha: 1)
        case 6...8:
            return UIColor(red: 174/255, green: 237/255, blue: 255/255, alpha: 1)
        case 17...19:
            return UIColor(red: 133/255, green: 89/255, blue: 136/255, alpha: 1)
        default:
            return UIColor(red: 0, green: 189/255, blue: 254/255, alpha: 1)
        }
    }
}
