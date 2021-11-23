//
//  WeatherServiceTestCase.swift
//  BaluchonTests
//
//  Created by JEAN SEBASTIEN BRUNET on 23/11/21.
//
// swiftlint:disable line_length

import XCTest
@testable import Baluchon

class WeatherServiceTestCase: XCTestCase {

    var service: WeatherService!

    override func tearDown() {
        TestUrlProtocol.loadingHandler = nil
        TestUrlProtocolWithError.loadingHandler = nil
        TestUrlProtocolWithNoWeatherData.loadingHandler = nil
    }

    func testGivenApiIsCalled_WhenFetchingData_CallbackShouldHaveTrueAndCorrectData() {

        let expected: WeatherForecast? = WeatherForecast(weatherId: "800", description: "clear sky", currentTemperature: "11.99", feelsLike: "10.52", minTemperature: "10.47", maxTemperature: "13.74", pressure: "1024", humidity: "49", speed: "0.45", cityName: "New York", country: "US")

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.weatherCorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = WeatherService(weatherSession: URLSession(configuration: configuration), weatherGeoSession: URLSession(configuration: configuration))
        service.getWeather(with: "lat=44.5594&lon=6.0786") { success, nycWeather, geoWeather in
            if success {
                XCTAssertEqual(nycWeather?.currentTemperature, expected?.currentTemperature)
                XCTAssertEqual(geoWeather?.humidity, expected?.humidity)
            } else {
                XCTFail("Request was not successful :/")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalled_WhenFetchingDataAndGettingIncorrectData_ThenCallbackShouldPostFalseAndNilNil() {

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.incorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = WeatherService(weatherSession: URLSession(configuration: configuration), weatherGeoSession: URLSession(configuration: configuration))
        service.getWeather(with: "lat=44.5594&lon=6.0786") { success, nycWeather, geoWeather in
            XCTAssertTrue(success == false)
            XCTAssertNil(nycWeather)
            XCTAssertNil(geoWeather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalled_WhenFetchingDataAndGettingBadResponse_ThenCallbackShouldPostFalseAndNilData() {

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            let data: Data? = FakeResponseData.weatherCorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = WeatherService(weatherSession: URLSession(configuration: configuration), weatherGeoSession: URLSession(configuration: configuration))
        service.getWeather(with: "lat=44.5594&lon=6.0786") { success, nycWeather, geoWeather in
            XCTAssertTrue(success == false)
            XCTAssertNil(nycWeather)
            XCTAssertNil(geoWeather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalled_WhenFetchingAndGettingAnError_CallbackShouldPostFalseAndNil() {

        TestUrlProtocolWithError.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.error
            let data: Data? = FakeResponseData.weatherCorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocolWithError.self]
        service = WeatherService(weatherSession: URLSession(configuration: configuration), weatherGeoSession: URLSession(configuration: configuration))
        service.getWeather(with: "lat=44.5594&lon=6.0786") { success, nycWeather, geoWeather in
            XCTAssertFalse(success)
            XCTAssertNil(nycWeather)
            XCTAssertNil(geoWeather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalled_WhenFetchingAndGettingNoData_CallbackShouldPostFalseAndNil() {

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = FakeResponseData.error
            let data: Data? = nil
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = WeatherService(weatherSession: URLSession(configuration: configuration), weatherGeoSession: URLSession(configuration: configuration))
        service.getWeather(with: "lat=44.5594&lon=6.0786") { success, nycWeather, geoWeather in
            XCTAssertFalse(success)
            XCTAssertNil(nycWeather)
            XCTAssertNil(geoWeather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForGeoloc_WhenFetchingDataAndGettingIncorrectData_ThenCallbackShouldPostNil() {

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.incorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = WeatherService(weatherSession: URLSession(configuration: configuration), weatherGeoSession: URLSession(configuration: configuration))
        service.getgeoLocatedWeather(with: "lat=44.5594&lon=6.0786") { geoWeather in
            XCTAssertNil(geoWeather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForGeoloc_WhenFetchingAndGettingNoData_CallbackShouldPostNil() {

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = FakeResponseData.error
            let data: Data? = nil
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = WeatherService(weatherSession: URLSession(configuration: configuration), weatherGeoSession: URLSession(configuration: configuration))
        service.getgeoLocatedWeather(with: "lat=44.5594&lon=6.0786") { geoWeather in
            XCTAssertNil(geoWeather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForGeoloc_WhenFetchingDataAndGettingBadResponse_ThenCallbackShouldPostFalseNil() {

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            let data: Data? = FakeResponseData.currencyCorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = WeatherService(weatherSession: URLSession(configuration: configuration), weatherGeoSession: URLSession(configuration: configuration))
        service.getgeoLocatedWeather(with: "lat=44.5594&lon=6.0786") { geoLocWeather in
            XCTAssertNil(geoLocWeather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalled_WhenFetchingAndGettingPartialData_CallbackShouldPostFalseAndNil() {

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.weatherCorrectData
            return (response, data, error)
        }
        TestUrlProtocolWithNoWeatherData.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = nil
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        let configurationWithError = URLSessionConfiguration.ephemeral
        configurationWithError.protocolClasses = [TestUrlProtocolWithNoWeatherData.self]
        service = WeatherService(weatherSession: URLSession(configuration: configuration), weatherGeoSession: URLSession(configuration: configurationWithError))
        service.getWeather(with: "lat=44.5594&lon=6.0786") { success, nycWeather, geoWeather in
            XCTAssertFalse(success)
            XCTAssertNil(nycWeather)
            XCTAssertNil(geoWeather)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

}
