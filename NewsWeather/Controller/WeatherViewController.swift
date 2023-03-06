//
//  WeatherViewController.swift
//  NewsWeather
//
//  Created by Pavel on 21.02.2023.
//

import UIKit
import SnapKit
import CoreLocation

class WeatherViewController: UIViewController {

    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        let weatherView = WeatherView()
        view.addSubview(weatherView)
        weatherView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        searchTextField.delegate = self
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        buttonLocation.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
        weatherManager.delegate = self
    }
}

//MARK: - extension Actions

@objc
extension WeatherViewController {
    func searchButtonPressed() {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }

    func locationButtonPressed() {
        locationManager.requestLocation()
    }
}


//MARK: - Extension UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)//прячет клавиатуру
        print(searchTextField.text!)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - extension WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didFailError(error: Error) {
        print(error)
    }

    func didUpdateWeather(_ weatherManger: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            labelNumber.text = weather.temperatureString
            conditionImage.image = UIImage(systemName: weather.conditionNameString)
            labelCity.text = weather.cityName
        }
    }
}

//MARK: - extension CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingHeading()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
