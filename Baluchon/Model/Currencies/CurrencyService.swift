//
//  CurrencyService.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 15/11/21.
//

import Foundation

/// This class is used to make calls to Fixer.io API
class CurrencyService {

    static var shared = CurrencyService()
    private init() {}

    private static var urlComponents = URLComponents()

    private static let key = "65d4c32593a7af53e05cfc96c7ecefda"

    private var task: URLSessionDataTask?
    private var currencySession = URLSession(configuration: .default)

    init(currencySession: URLSession) {
        self.currencySession = currencySession
    }

}

// MARK: - API CALL

extension CurrencyService {

    /// This function calls the Fixer.io API.
    /// - Parameter callback: a closure which posts a boolean value, and a Rates optionnal object.
    func getRates(callback: @escaping (Bool, Rates?) -> Void) {

        let url = setURL()

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        task?.cancel()
        task = currencySession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(Rates.self, from: data) else {
                    callback(false, nil)
                    return
                }
                callback(true, responseJSON)
            }
        }
        task?.resume()
    }

    /// This function returns an URL.
    /// It is used to set the url of subsequent request,
    ///  for given currencies, Euro based.
    private func setURL() -> URL {
        CurrencyService.urlComponents.scheme = "http"
        CurrencyService.urlComponents.host = "data.fixer.io"
        CurrencyService.urlComponents.path = "/api/latest"
        CurrencyService.urlComponents.queryItems = [
            URLQueryItem(name: "access_key", value: CurrencyService.key),
            URLQueryItem(name: "symbols", value: "USD,EUR,CAD,GBP,JPY"),
            URLQueryItem(name: "base", value: "EUR")
        ]
        let url = CurrencyService.urlComponents.url
        return url!
    }

}
