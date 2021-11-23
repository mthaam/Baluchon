//
//  DecodedCurrency.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 15/11/21.
//

import Foundation

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

struct AllRates: Decodable, Encodable, Equatable {
    var USD: Double
    var EUR: Int
    var CAD: Double
    var GBP: Double
    var JPY: Double
}
