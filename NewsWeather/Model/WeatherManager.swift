//
//  WeatherManager.swift
//  NewsWeather
//
//  Created by Pavel on 21.02.2023.
//

protocol WeatherManagerDelegate {

    func didUpdateWeather(_ weatherManger: WeatherManager, weather: WeatherModel)
    func didFailError(error: Error)
}

import Foundation
import CoreLocation
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=aea7447a6cf427ee91424acda7a4a5ea&units=metric"
    var delegate: WeatherManagerDelegate?
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }

    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        //1. Create URL
        if let url = URL(string: urlString) {
            //2. Create a UrlSessions
            /* создание объекта сеанса URL который похож на браузер*/
            let session = URLSession(configuration: .default)
            //3. Give the session task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) { // if let weather = self.parseJSON(weatherData: safeData)
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }

    func parseJSON(_ weatherData: Data) -> WeatherModel? { // func parseJSON(weatherData: Data) -> WeatherModel?
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp

            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailError(error: error)
            return nil
        }
    }
}

