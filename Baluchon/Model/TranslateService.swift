//
//  TranslateService.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 12/11/21.
//
// swiftlint:disable line_length

import Foundation

class TranslateService {

    static var shared = TranslateService()
    private init() {}

    private static var urlComponents = URLComponents()

    private static let key = "AIzaSyAqggqoDqInxikohkwtyPlw4x7sEe6Vgs4"

    private var task: URLSessionDataTask?
    private var translateSession = URLSession(configuration: .default)

    init(translateSession: URLSession) {
        self.translateSession = translateSession
    }

}

extension TranslateService {

    func translate(from: String, toLang: String, autoDetect: Bool, text: String, callback: @escaping (Bool, TranslatedData?) -> Void) {
        TranslateService.urlComponents.scheme = "https"
        TranslateService.urlComponents.host = "translation.googleapis.com"
        TranslateService.urlComponents.path = "/language/translate/v2"
        TranslateService.urlComponents.queryItems = [
            URLQueryItem(name: "key", value: TranslateService.key),
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "target", value: toLang)
        ]

        guard let url = TranslateService.urlComponents.url else {
            callback(false, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        task?.cancel()

        task = translateSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                guard let responseJSON = try? JSONDecoder().decode(TranslationJsonToDecode.self, from: data) else {
                    callback(false, nil)
                    return
                }

                let translatedData = self.parseJsonData(decodedJSON: responseJSON)
                callback(true, translatedData)

            }
        }
        task?.resume()
    }

//    func getgeoLocatedWeather(with coordinates: String, completionHandler: @escaping (WeatherForecast?) -> Void) {
//        task?.cancel()
//        guard let geolocURL = getUrlWithGeolocCoordinates(with: coordinates) else { return }

//        task = translateSession.dataTask(with: geolocURL) { data, response, error in
//            DispatchQueue.main.async {
//                guard let data = data, error == nil else {
//                    completionHandler(nil)
//                    return
//                }
//                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                    completionHandler(nil)
//                    return
//                }
//                guard let responseJSON = try? JSONDecoder().decode(DecodedWeatherForecast.self, from: data) else {
//                    completionHandler(nil)
//                    return
//                }
//                let weather = self.parseJsonData(decodedJSON: responseJSON)
//
//                completionHandler(weather)
//            }
//        }
//        task?.resume()
//    }

}

extension TranslateService {

    private func parseJsonData(decodedJSON: TranslationJsonToDecode ) -> TranslatedData {
        var text = String()
        var language = String()

        for translationOccurence in decodedJSON.data.translations {
            if let translation = translationOccurence.translatedText {
                text.append(translation)
            }
        }

        if let detectedLanguage = decodedJSON.data.translations[0].detectedLanguageSource {
            language = detectedLanguage
        }

        let translatedData = TranslatedData(text: text, target: language)
        return translatedData
    }

}
