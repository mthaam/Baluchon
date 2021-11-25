//
//  WeatherService.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 7/11/21.
// swiftlint:disable line_length
//

import Foundation

/// This class is used to make calls to OpenWeatherMap API
class WeatherService {
    static var shared = WeatherService()
    private init() {}

    private static let baseOpenWeatherURL = "https://api.openweathermap.org/data/2.5/weather?"
    private static let newYorkCoordinates = "lat=40.712776&lon=-74.005974"
    private static let unitsAndLangParams = "&units=metric&lang=en"
    private static let appID = "&appid=600246c77697068679ac944befd7a166"
    private static var completeNewYorkURL: String {baseOpenWeatherURL+newYorkCoordinates+unitsAndLangParams+appID}

    private var task: URLSessionDataTask?
    private var weatherSession = URLSession(configuration: .default)
    private var weatherGeoSession = URLSession(configuration: .default)

    init(weatherSession: URLSession, weatherGeoSession: URLSession) {
        self.weatherSession = weatherSession
        self.weatherGeoSession = weatherGeoSession
    }

}

// MARK: - API CALLS

extension WeatherService {

    /// This functions calls the OpenWeatherMap API.
    /// - Parameter coordinates : A string value sent by WeatherViewController, reprensenting users's current GPS coordinates
    /// - Parameter callback : a closure posting a boolean, and 2 WeatherForecast objects (1 per location)
    /// - Note that a geo located call is made within dataTask closure's body.
    func getWeather(with coordinates: String, callback: @escaping (Bool, WeatherForecast?, WeatherForecast?) -> Void) {
        task?.cancel()
        guard let url = URL(string: WeatherService.completeNewYorkURL ) else { return }

        task = weatherSession.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(DecodedWeatherForecast.self, from: data) else {
                    callback(false, nil, nil)
                    return
                }
                self.getgeoLocatedWeather(with: coordinates) { geoLocatedForecast in
                    guard geoLocatedForecast != nil else {
                        callback(false, nil, nil)
                        return }
                    let newYorkWeather = self.parseJsonData(decodedJSON: responseJSON)
                    let geoLocatedWeather = geoLocatedForecast
                    callback(true, newYorkWeather, geoLocatedWeather)
                }
            }
        }
        task?.resume()
    }

    /// This functions calls the OpenWeatherMap API, based on user's current GPS coordinates.
    /// - Parameter coordinates : A string value sent by WeatherViewController, reprensenting users's current GPS coordinates
    /// - Parameter callback : a closure posting a WeatherForecast object.
    func getgeoLocatedWeather(with coordinates: String, completionHandler: @escaping (WeatherForecast?) -> Void) {
        task?.cancel()
        guard let geolocURL = getUrlWithGeolocCoordinates(with: coordinates) else { return }

        task = weatherGeoSession.dataTask(with: geolocURL) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completionHandler(nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completionHandler(nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(DecodedWeatherForecast.self, from: data) else {
                    completionHandler(nil)
                    return
                }
                let weather = self.parseJsonData(decodedJSON: responseJSON)
                completionHandler(weather)
            }
        }
        task?.resume()
    }

}

// MARK: - SUPPORTING PRIVATE FUNCTIONS

extension WeatherService {

    /// This functions returns an URL
    /// - Parameter coordinates : a string value reprensenting user's current GPS coordinates.
    private func getUrlWithGeolocCoordinates(with coordinates: String) -> URL? {
        var urlString = WeatherService.baseOpenWeatherURL
        urlString += coordinates
        urlString += WeatherService.unitsAndLangParams
        urlString += WeatherService.appID
        return URL(string: urlString)

    }

    /// This function returns a WeatherForecast object.
    /// - Parameter decodedJSON: An oject created using JSONDecoder().decode
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
        let country = String(decodedJSON.sys.country)

        let weather = WeatherForecast(weatherId: weatherId, description: description, currentTemperature: currentTemperature, feelsLike: feelsLike, minTemperature: minTemperature, maxTemperature: maxTemperature, pressure: pressure, humidity: humidity, speed: speed, cityName: cityName, country: country)
        return weather
    }

}
