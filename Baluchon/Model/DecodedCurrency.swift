//
//  DecodedCurrency.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 15/11/21.
//

import Foundation

struct Rates: Decodable {
    var base: String?
    var date: String?
    var rates: AllRates?
}

struct AllRates: Decodable {
    var USD: Double
    var EUR: Int
    var CAD: Double
    var GBP: Double
    var JPY: Double
}
