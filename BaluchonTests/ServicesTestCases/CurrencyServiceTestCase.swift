//
//  CurrencyServiceTestCase.swift
//  BaluchonTests
//
//  Created by JEAN SEBASTIEN BRUNET on 21/11/21.
//

import XCTest
@testable import Baluchon

class CurrencyServiceTestCase: XCTestCase {

    var service: CurrencyService!

    override func tearDown() {
        TestUrlProtocol.loadingHandler = nil
        TestUrlProtocolWithError.loadingHandler = nil
    }

    func testGivenApiIsCalled_WhenFetchingData_CallbackShouldHaveTrueAndCorrectData() {

        let rates: AllRates? = AllRates(USD: 1.136951, EUR: 1, CAD: 1.432997, GBP: 0.842487, JPY: 129.920578)
        let expected: Rates? = Rates(base: "EUR", date: "2021-11-18", rates: rates)

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.currencyCorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = CurrencyService(currencySession: URLSession(configuration: configuration))
        service.getRates { success, rates in
            if success {
                XCTAssertEqual(rates?.date, expected?.date)
            } else {
                XCTFail("Request was not successful :/")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalled_WhenFetchingDataAndGettingIncorrectData_ThenCallbackShouldPostFalseAndNil() {

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = FakeResponseData.error
            let data: Data? = FakeResponseData.incorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = CurrencyService(currencySession: URLSession(configuration: configuration))
        service.getRates { success, rates in
            XCTAssertTrue(success == false)
            XCTAssertNil(rates)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalled_WhenFetchingDataAndGettingBadResponse_ThenCallbackShouldPostFalseAndNilData() {

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = nil
            let data: Data? = FakeResponseData.currencyCorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = CurrencyService(currencySession: URLSession(configuration: configuration))
        service.getRates { success, rates in
            XCTAssertTrue(success == false)
            XCTAssertNil(rates)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalled_WhenFetchingAndGettingAnError_CallbackShouldPostFalseAndNil() {

        TestUrlProtocolWithError.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = FakeResponseData.error
            let data: Data? = FakeResponseData.currencyCorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocolWithError.self]
        service = CurrencyService(currencySession: URLSession(configuration: configuration))
        service.getRates { success, rates in
            XCTAssertFalse(success)
            XCTAssertNil(rates)
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
        service = CurrencyService(currencySession: URLSession(configuration: configuration))
        service.getRates { success, rates in
            XCTAssertFalse(success)
            XCTAssertNil(rates)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

}
