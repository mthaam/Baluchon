//
//  WeatherForecast.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 8/11/21.
//
// swiftlint:disable identifier_name

import Foundation

struct WeatherForecast {
    let weatherId: String
    let description: String
    let currentTemperature: String
    let feelsLike: String
    let minTemperature: String
    let maxTemperature: String
    let pressure: String
    let humidity: String
    let speed: String
    let cityName: String
    let country: String
}

struct DecodedWeatherForecast: Decodable {
    var weather: [Weather]
    var main: Temperatures
    var wind: Wind
    var name: String
    var sys: Country
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

struct Country: Decodable {
    var country: String
}

struct Wind: Decodable {
    var speed: Double
}
