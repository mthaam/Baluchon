//
//  TranslateServiceTestCase.swift
//  BaluchonTests
//
//  Created by JEAN SEBASTIEN BRUNET on 23/11/21.
//
// swiftlint:disable line_length
// swiftlint:disable type_body_length

import XCTest
@testable import Baluchon

class TranslateServiceTestCase: XCTestCase {

    var service: TranslateService!

    override func tearDown() {
        TestUrlProtocol.loadingHandler = nil
        TestUrlProtocolWithError.loadingHandler = nil
        TestUrlProtocolWithNoWeatherData.loadingHandler = nil
        TestUrlProtocolTranslation.loadingHandler = nil
    }

    // MARK: - AVAILABLE LANGUAGE TESTS

    func testGivenApiIsCalledForAvailableLanguagesWithFrenchTarget_WhenFetchingData_CallbackShouldPostCorrectLanguage() {

        let expected: String? = "English"

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.languageEntriesCorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = TranslateService(translateSession: URLSession(configuration: configuration), detectionSession: URLSession(configuration: configuration), availableLanguagesSession: URLSession(configuration: configuration))
        service.checkAvailableLanguagesFor(source: "en", target: "French") { confirmedLanguage in
            XCTAssertEqual(confirmedLanguage, expected)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForAvailableLanguagesWithEnglishTarget_WhenFetchingData_CallbackShouldPostCorrectLanguage() {

        let expected: String? = "English"

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.languageEntriesCorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = TranslateService(translateSession: URLSession(configuration: configuration), detectionSession: URLSession(configuration: configuration), availableLanguagesSession: URLSession(configuration: configuration))
        service.checkAvailableLanguagesFor(source: "en", target: "English") { confirmedLanguage in
            XCTAssertEqual(confirmedLanguage, expected)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForAvailableLanguagesWithUnknownTarget_WhenFetchingData_CallbackShouldPostCorrectLanguage() {

        let expected: String? = "English"

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.languageEntriesCorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = TranslateService(translateSession: URLSession(configuration: configuration), detectionSession: URLSession(configuration: configuration), availableLanguagesSession: URLSession(configuration: configuration))
        service.checkAvailableLanguagesFor(source: "en", target: "Martian") { confirmedLanguage in
            XCTAssertEqual(confirmedLanguage, expected)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForLanguages_WhenFetchingAndThereIsAnError_CallbackShouldPostNil() {

        TestUrlProtocolWithError.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.error
            let data: Data? = FakeResponseData.detectionCorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configurationDetection = URLSessionConfiguration.ephemeral
        configurationDetection.protocolClasses = [TestUrlProtocolWithError.self]
        service = TranslateService(translateSession: URLSession(configuration: configurationDetection), detectionSession: URLSession(configuration: configurationDetection), availableLanguagesSession: URLSession(configuration: configurationDetection))
        service.checkAvailableLanguagesFor(source: "en", target: "") { confirmedLanguage in
            XCTAssertNil(confirmedLanguage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForLanguages_WhenFetchingAndGettingBadResponse_CallbackShouldPostFalseAndNil() {

        TestUrlProtocolWithNoWeatherData.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = nil
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configurationDetection = URLSessionConfiguration.ephemeral
        configurationDetection.protocolClasses = [TestUrlProtocolWithNoWeatherData.self]
        service = TranslateService(translateSession: URLSession(configuration: configurationDetection), detectionSession: URLSession(configuration: configurationDetection), availableLanguagesSession: URLSession(configuration: configurationDetection))
        service.checkAvailableLanguagesFor(source: "en", target: "") { confirmedLanguage in
            XCTAssertNil(confirmedLanguage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForLanguages_WhenFetchingAndGettingCorruptedData_CallbackShouldPostFalseAndNil() {

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.incorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = TranslateService(translateSession: URLSession(configuration: configuration), detectionSession: URLSession(configuration: configuration), availableLanguagesSession: URLSession(configuration: configuration))
        service.checkAvailableLanguagesFor(source: "en", target: "English") { confirmedLanguage in
            XCTAssertNil(confirmedLanguage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    // MARK: - LANGUAGE DETECTION TESTS

    func testGivenApiIsCalledForDetection_WhenFetchingData_CallbackShouldPostTrueAndCorrectLanguage() {

        let expected: String? = "English"

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.detectionCorrectData
            return (response, data, error)
        }
        TestUrlProtocolTranslation.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.languageEntriesCorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configurationDetection = URLSessionConfiguration.ephemeral
        configurationDetection.protocolClasses = [TestUrlProtocol.self]
        let configurationLanguages = URLSessionConfiguration.ephemeral
        configurationLanguages.protocolClasses = [TestUrlProtocolTranslation.self]
        service = TranslateService(translateSession: URLSession(configuration: configurationDetection), detectionSession: URLSession(configuration: configurationDetection), availableLanguagesSession: URLSession(configuration: configurationLanguages))
        service.detectInputLanguage(text: "It doesn't matter", target: "English") { success, confirmedLanguage in
            XCTAssertTrue(success)
            XCTAssertEqual(confirmedLanguage, expected)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForDetection_WhenFetchingAndThereIsAnError_CallbackShouldPostFalseAndNil() {

        TestUrlProtocolWithError.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.error
            let data: Data? = FakeResponseData.detectionCorrectData
            return (response, data, error)
        }
        TestUrlProtocolTranslation.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.languageEntriesCorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configurationDetection = URLSessionConfiguration.ephemeral
        configurationDetection.protocolClasses = [TestUrlProtocolWithError.self]
        let configurationLanguages = URLSessionConfiguration.ephemeral
        configurationLanguages.protocolClasses = [TestUrlProtocolTranslation.self]
        service = TranslateService(translateSession: URLSession(configuration: configurationDetection), detectionSession: URLSession(configuration: configurationDetection), availableLanguagesSession: URLSession(configuration: configurationLanguages))
        service.detectInputLanguage(text: "It doesn't matter", target: "English") { success, confirmedLanguage in
            XCTAssertFalse(success)
            XCTAssertNil(confirmedLanguage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForDetection_WhenFetchingAndGettingBadResponse_CallbackShouldPostFalseAndNil() {

        TestUrlProtocolWithNoWeatherData.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = nil
            return (response, data, error)
        }
        TestUrlProtocolTranslation.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.languageEntriesCorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configurationDetection = URLSessionConfiguration.ephemeral
        configurationDetection.protocolClasses = [TestUrlProtocolWithNoWeatherData.self]
        let configurationLanguages = URLSessionConfiguration.ephemeral
        configurationLanguages.protocolClasses = [TestUrlProtocolTranslation.self]
        service = TranslateService(translateSession: URLSession(configuration: configurationDetection), detectionSession: URLSession(configuration: configurationDetection), availableLanguagesSession: URLSession(configuration: configurationLanguages))
        service.detectInputLanguage(text: "It doesn't matter", target: "English") { success, confirmedLanguage in
            XCTAssertFalse(success)
            XCTAssertNil(confirmedLanguage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForDetection_WhenFetchingAndGettingCorruptedData_CallbackShouldPostFalseAndNil() {

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.incorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        service = TranslateService(translateSession: URLSession(configuration: configuration), detectionSession: URLSession(configuration: configuration), availableLanguagesSession: URLSession(configuration: configuration))
        service.detectInputLanguage(text: "It doesn't matter", target: "English") { success, confirmedLanguage in
            XCTAssertFalse(success)
            XCTAssertNil(confirmedLanguage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForDetection_WhenFetchingLanguagesAndCallbackPOstsNil_CallbackShouldPostFalseAndNil() {

        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.detectionCorrectData
            return (response, data, error)
        }
        TestUrlProtocolTranslation.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.incorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Loading...")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestUrlProtocol.self]
        let configurationDetection = URLSessionConfiguration.ephemeral
        configurationDetection.protocolClasses = [TestUrlProtocolTranslation.self]
        service = TranslateService(translateSession: URLSession(configuration: configuration), detectionSession: URLSession(configuration: configuration), availableLanguagesSession: URLSession(configuration: configurationDetection))
        service.detectInputLanguage(text: "It doesn't matter", target: "English") { success, confirmedLanguage in
            XCTAssertFalse(success)
            XCTAssertNil(confirmedLanguage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    // MARK: - COMPLETE TRANSLATION TESTS (CHAINED CALL OF TRANSLATION + DETECTION + AVAILABLE LANGUAGES)

    func testGivenApiIsCalledForTranslation_WhenFetchingAndAutoDetectIsRequested_CallbackShouldPostTrueAndEnglishAsDetectedLanguage() {

        let expectedTranslation = "What's your dog's name"
        let expectedLanguageDetected = "English"
        TestUrlProtocolTranslation.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.translationCorrectData
            return (response, data, error)
        }
        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.detectionCorrectData
            return (response, data, error)
        }
        TestUrlProtocolAvailableLanguages.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.languageEntriesCorrectData
            return (response, data, error)
        }
        let expectation = XCTestExpectation(description: "Loading...")
        let configurationTranslation = URLSessionConfiguration.ephemeral
        configurationTranslation.protocolClasses = [TestUrlProtocolTranslation.self]
        let configurationDetection = URLSessionConfiguration.ephemeral
        configurationDetection.protocolClasses = [TestUrlProtocol.self]
        let configurationLanguages = URLSessionConfiguration.ephemeral
        configurationLanguages.protocolClasses = [TestUrlProtocolAvailableLanguages.self]
        service = TranslateService(translateSession: URLSession(configuration: configurationTranslation), detectionSession: URLSession(configuration: configurationDetection), availableLanguagesSession: URLSession(configuration: configurationLanguages))
        service.translate(from: "French", toLang: "fr", autoDetect: true, text: "Comment s'appelle ton chien") { success, translation, detectedLanguage in
            XCTAssertEqual(translation?.text, expectedTranslation)
            XCTAssertEqual(detectedLanguage, expectedLanguageDetected)
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForTranslation_WhenFetchingAndNoDataWasReceived_CallbackShouldPostFalseAndNilNil() {
        TestUrlProtocolWithError.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.error
            let data: Data? = FakeResponseData.detectionCorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configurationTranslation = URLSessionConfiguration.ephemeral
        configurationTranslation.protocolClasses = [TestUrlProtocolWithError.self]
        service = TranslateService(translateSession: URLSession(configuration: configurationTranslation), detectionSession: URLSession(configuration: configurationTranslation), availableLanguagesSession: URLSession(configuration: configurationTranslation))
        service.translate(from: "French", toLang: "fr", autoDetect: true, text: "Comment s'appelle ton chien") { success, translation, detectedLanguage in
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            XCTAssertNil(detectedLanguage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForTranslation_WhenFetchingAndThereIsABadResponse_CallbackShouldPostFalseAndNilNil() {
        TestUrlProtocolWithNoWeatherData.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseKO
            let error: Error? = FakeResponseData.error
            let data: Data? = nil
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configurationTranslation = URLSessionConfiguration.ephemeral
        configurationTranslation.protocolClasses = [TestUrlProtocolWithNoWeatherData.self]
        service = TranslateService(translateSession: URLSession(configuration: configurationTranslation), detectionSession: URLSession(configuration: configurationTranslation), availableLanguagesSession: URLSession(configuration: configurationTranslation))
        service.translate(from: "French", toLang: "fr", autoDetect: true, text: "Comment s'appelle ton chien") { success, translation, detectedLanguage in
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            XCTAssertNil(detectedLanguage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testGivenApiIsCalledForTranslation_WhenFetchingAndReceivedDataIsCorrupted_CallbackShouldPostFalseAndNilNil() {
        TestUrlProtocol.loadingHandler = { _ in
            let response: HTTPURLResponse = FakeResponseData.responseOK
            let error: Error? = nil
            let data: Data? = FakeResponseData.incorrectData
            return (response, data, error)
        }

        let expectation = XCTestExpectation(description: "Loading...")
        let configurationTranslation = URLSessionConfiguration.ephemeral
        configurationTranslation.protocolClasses = [TestUrlProtocol.self]
        service = TranslateService(translateSession: URLSession(configuration: configurationTranslation), detectionSession: URLSession(configuration: configurationTranslation), availableLanguagesSession: URLSession(configuration: configurationTranslation))
        service.translate(from: "French", toLang: "fr", autoDetect: true, text: "Comment s'appelle ton chien") { success, translation, detectedLanguage in
            XCTAssertFalse(success)
            XCTAssertNil(translation)
            XCTAssertNil(detectedLanguage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

}
