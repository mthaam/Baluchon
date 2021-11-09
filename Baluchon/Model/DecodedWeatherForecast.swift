//
//  WeatherForecast.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 8/11/21.
//
// swiftlint:disable all

import Foundation

struct WeatherForecast {
    let weatherId: String
    let description: String
    let currentTemperature: String
    let feels_like: String
    let minTemperature: String
    let maxTemperature: String
    let pressure: String
    let humidity: String
    let speed: String
    let cityName: String
}

struct DecodedWeatherForecast: Decodable {
    var weather: [Weather]
    var main: Temperatures
    var wind: Wind
    var name: String
}

struct Weather: Decodable {
    var id: Int
    var description: String
}

struct Temperatures: Decodable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}

struct Wind: Decodable {
    var speed: Double
}
