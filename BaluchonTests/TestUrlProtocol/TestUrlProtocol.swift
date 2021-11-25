//
//  TestUrlProtocol.swift
//  BaluchonTests
//
//  Created by JEAN SEBASTIEN BRUNET on 21/11/21.
//
// swiftlint:disable large_tuple

import XCTest
import Foundation
@testable import Baluchon

class TestUrlProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?

    override func startLoading() {
        guard let handler = TestUrlProtocol.loadingHandler else {
            XCTFail("Loading handler is not properly set.")
            return
        }
        let (response, data, error) = handler(request)
        if let data = data {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } else {
            client?.urlProtocol(self, didFailWithError: error!)
        }
    }

    override func stopLoading() {}
}

class TestUrlProtocolWithError: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?

    override func startLoading() {
        guard let handler = TestUrlProtocolWithError.loadingHandler else {
            XCTFail("Loading handler is not properly set.")
            return
        }
        let (response, data, error) = handler(request)
        if let data = data {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocol(self, didFailWithError: error!)
            client?.urlProtocolDidFinishLoading(self)
        }

    }

    override func stopLoading() {}
}

class TestUrlProtocolWithNoWeatherData: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?

    override func startLoading() {
        guard let handler = TestUrlProtocolWithNoWeatherData.loadingHandler else {
            XCTFail("Loading handler is not properly set.")
            return
        }
        let (response, data, _) = handler(request)
        if let data = data {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }

    }

    override func stopLoading() {}
}

class TestUrlProtocolTranslation: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?

    override func startLoading() {
        guard let handler = TestUrlProtocolTranslation.loadingHandler else {
            XCTFail("Loading handler is not properly set.")
            return
        }
        let (response, data, error) = handler(request)
        if let data = data {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } else {
            client?.urlProtocol(self, didFailWithError: error!)
        }
    }

    override func stopLoading() {}
}

class TestUrlProtocolAvailableLanguages: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    static var loadingHandler: ((URLRequest) -> (HTTPURLResponse, Data?, Error?))?

    override func startLoading() {
        guard let handler = TestUrlProtocolAvailableLanguages.loadingHandler else {
            XCTFail("Loading handler is not properly set.")
            return
        }
        let (response, data, error) = handler(request)
        if let data = data {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } else {
            client?.urlProtocol(self, didFailWithError: error!)
        }
    }

    override func stopLoading() {}
}
