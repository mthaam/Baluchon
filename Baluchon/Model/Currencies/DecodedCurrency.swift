//
//  DecodedCurrency.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 15/11/21.
//

import Foundation

/// This strurcture matches the objects received from call in JSON data for currency rates.
/// It conforms to Decodable and Encodable protocols.
/// - Note that Equatable protocol is used for unit testing purposes.
struct Rates: Decodable, Encodable, Equatable {

    static func == (lhs: Rates, rhs: Rates) -> Bool {
        return (
        lhs.base == rhs.base &&
        lhs.date == rhs.base &&
        lhs.rates == rhs.rates
        )
    }

    var base: String?
    var date: String?
    var rates: AllRates?
}

/// This strurcture matches the objects received from call in JSON data for translation
/// It conforms to Decodable and Encodable protocols.
/// - Note that Equatable protocol is used for unit testing purposes.
struct AllRates: Decodable, Encodable, Equatable {
    var USD: Double
    var EUR: Int
    var CAD: Double
    var GBP: Double
    var JPY: Double
}
