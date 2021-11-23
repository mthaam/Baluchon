//
//  FakeResponseData.swift
//  BaluchonTests
//
//  Created by JEAN SEBASTIEN BRUNET on 21/11/21.
// swiftlint:disable force_try

import Foundation

class FakeResponseData {

    // MARK: - Data
    static var currencyCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "FakeRates", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var weatherCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "FakeWeatherForecast", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var translationCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "TranslationContent", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var detectionCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "TranslationDetectionContent", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var languageEntriesCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "TranslationLanguageEntries", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var incorrectData = "Error".data(using: .utf8)

    // MARK: - Response

    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://www.apple.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://www.apple.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!

    // MARK: - Error

    class ApiError: Error {}
    static let error: ApiError? = ApiError()
}
