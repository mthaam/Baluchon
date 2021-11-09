//
//  WeatherService.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 7/11/21.
// swiftlint:disable line_length
//

import Foundation

class WeatherService {
    static var shared = WeatherService()
    private init() {}

    private static let openWeatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=40.712776&lon=-74.005974&units=metric&lang=en&appid=600246c77697068679ac944befd7a166")!
    private var task: URLSessionDataTask?
    private var weatherSession = URLSession(configuration: .default)

    init(weatherSession: URLSession) {
        self.weatherSession = weatherSession
    }

    func getNYCWeather(callback: @escaping (Bool, WeatherForecast?) -> Void) {
        task?.cancel()

        task = weatherSession.dataTask(with: WeatherService.openWeatherURL) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(DecodedWeatherForecast.self, from: data) else {
                    print("Error: Couldn't decode data into Blog")
                    return
                }
                print("weatherId: \(responseJSON.weather[0].id)")
                print("weatherId: \(responseJSON.weather[0].description)")
                let weather = self.parseJsonData(decodedJSON: responseJSON)
                callback(true, weather)
            }
        }
        task?.resume()
    }

    private func parseJsonData(decodedJSON: DecodedWeatherForecast) -> WeatherForecast {
        let weatherId = String(decodedJSON.weather[0].id)
        let description = decodedJSON.weather[0].description
        let currentTemperature = String(decodedJSON.main.temp)
        let feelsLike = String(decodedJSON.main.feels_like)
        let minTemperature = String(decodedJSON.main.temp_min)
        let maxTemperature = String(decodedJSON.main.temp_max)
        let pressure = String(decodedJSON.main.pressure)
        let humidity = String(decodedJSON.main.humidity)
        let speed = String(decodedJSON.wind.speed)
        let cityName = String(decodedJSON.name)

        let weather = WeatherForecast(weatherId: weatherId, description: description, currentTemperature: currentTemperature, feels_like: feelsLike, minTemperature: minTemperature, maxTemperature: maxTemperature, pressure: pressure, humidity: humidity, speed: speed, cityName: cityName)
        return weather
    }
}
