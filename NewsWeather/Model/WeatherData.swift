//
//  WeatherData.swift
//  NewsWeather
//
//  Created by Pavel on 25.02.2023.
//

import Foundation
struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
