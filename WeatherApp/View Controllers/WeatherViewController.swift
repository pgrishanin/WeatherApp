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
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet var cloudyImage: UIImageView!
    @IBOutlet var rainImage: UIImageView!
    @IBOutlet var sunImage: UIImageView!
    @IBOutlet var moonImage: UIImageView!
    @IBOutlet var snowImage: UIImageView!
    
    @IBOutlet var errorView: UIView!
    
    private let cities = City.cityList()
    private var selectedCity = City(name: "", latitude: 0, longitude: 0, timezone: "")
    private var selectedDate = Date()
    private var currentImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityPicker.delegate = self
        cityPicker.dataSource = self
        
        datePicker.minimumDate = Date()
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        loadingIndicator.hidesWhenStopped = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        
        if let city = cities.first {
            selectedCity = city
            updateData()
        }
    }
    
    @IBAction func dateChange(_ sender: UIDatePicker) {
        selectedDate = sender.date
        updateData()
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        updateData()
    }
}

extension WeatherViewController {
    
    private func updateData() {
        loadingIndicator.startAnimating()
        
        WeatherService.shared.fetchWeather(
            latitude: selectedCity.latitude,
            longitude: selectedCity.longitude,
            date: selectedDate
        ) { weather in
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.update(temperature: weather.t ?? 0)
                self.updateView(weather)
                self.errorIsHiddenToggle(to: true)
            }
        } onError: { error in
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.errorIsHiddenToggle(to: false)
            }
        }
    }
    
    private func update(temperature: Int) {
        UIView.transition(
            with: temperatureLabel,
            duration: 0.3,
            options: [.transitionCrossDissolve],
            animations: {
                self.temperatureLabel.text = "\(temperature)°C"
            },
            completion: nil
        )
    }
    
    private func updateView(_ weather: Weather) {
        var calendar = Calendar.current
        var newImage: UIImageView?

        if let timeZone = TimeZone(identifier: selectedCity.timezone) {
           calendar.timeZone = timeZone
        }
        let hour = calendar.component(.hour, from: selectedDate)
        
        
        if let rain = weather.crain {
            if rain > 0 {
                newImage = rainImage
            }
        } else if let snow = weather.csnow {
            if snow > 0 {
                newImage = snowImage
            }
        }
        
        if newImage == nil {
            if let _ = weather.tcc {
                if (6...18).contains(hour) {
                    
                } else {
                    
                }
            } else {
                if (6...18).contains(hour) {
                    newImage = sunImage
                } else {
                    newImage = moonImage
                }
            }
        }
        
        // Sky color animation
        UIView.animate(
            withDuration: 0.6,
            delay: 0.0,
            options:[],
            animations: {
                self.view.backgroundColor = AppSettingsService.shared.getSkyColors(byHour: hour)
            },
            completion:nil
        )
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0.0,
            options:[],
            animations: {
                self.currentImage?.isHidden = true
                newImage?.isHidden = false
            },
            completion:nil
        )
        
        currentImage = newImage
    }
    
    private func errorIsHiddenToggle(to value: Bool) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options:[],
            animations: {
                self.errorView.isHidden = value
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
        selectedCity = cities[row]
        updateData()
    }
}

