//
//  ViewController.swift
//  WeatherApp
//
//  Created by Pavel Grishanin on 13.11.2020.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet var cityPicker: UIPickerView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var skyView: UIView!
    
    private let cities = City.cityList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityPicker.delegate = self
        cityPicker.dataSource = self
        
        if let city = cities.first {
            change(city: city)
        }
    }

    private func change(city: City) {
        updateSky(timezone: city.timezone)
        
        WeatherService.shared.fetchWeather(
            latitude: city.latitude,
            longitude: city.longitude
        ) { weather in
            DispatchQueue.main.async {
                self.temperatureLabel.text = "\(weather.t ?? 0)°C"
            }
        } onError: { error in
            print(error)
        }
    }
    
    private func updateSky(timezone: String) {
        let date = Date()
        var calendar = Calendar.current

        if let timeZone = TimeZone(identifier: timezone) {
           calendar.timeZone = timeZone
        }
        let hour = calendar.component(.hour, from: date)
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0.0,
            options:[],
            animations: {
                self.skyView.backgroundColor = AppSettingsService.shared.getSkyColors(byHour: hour)
            },
            completion:nil
        )
        
    }
}

// MARK PickerView Delegate/DataSource
extension WeatherViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        cities.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(
            string: cities[row].name,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .bold)
            ]
        )
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        change(city: cities[row])
    }
    
}

