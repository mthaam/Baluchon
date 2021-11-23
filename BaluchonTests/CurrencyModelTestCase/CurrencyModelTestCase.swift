//
//  CurrencyModelTestCase.swift
//  BaluchonTests
//
//  Created by JEAN SEBASTIEN BRUNET on 20/11/21.
//
// swiftlint:disable line_length

import XCTest
@testable import Baluchon

class CurrencyModelTestCase: XCTestCase {
    var currencyCalculation: CurrencyTreatment!
    var rates: Rates!

    override func setUp() {
        super.setUp()
        currencyCalculation = CurrencyTreatment()
        rates = createRates()
    }

    private func createRates() -> Rates? {
        let allRates: AllRates? = AllRates(USD: 1.1, EUR: 1, CAD: 1.3, GBP: 1.4, JPY: 1.5)
        let rates = Rates(base: "GBP", date: "2021-10-11", rates: allRates)
        return rates
    }

    func testGivenOutputStringContainsAValue_WhenClearing_OutputStringShouldHave0Value() {
        currencyCalculation.outputString = "12"

        currencyCalculation.clear()

        XCTAssertTrue(currencyCalculation.outputString == "0")
    }

    func testGivenRatesWereReceivedFromApi_WhenUpdatingCurrencies_CurrenciesArrayShouldHaveValues() {
        currencyCalculation.updateListedCurrencies(with: rates)

        XCTAssertEqual(currencyCalculation.listedCurrencies["USD"], 1.1)
        XCTAssertEqual(currencyCalculation.listedCurrencies["EUR"], 1.0)
        XCTAssertEqual(currencyCalculation.listedCurrencies["CAD"], 1.3)
        XCTAssertEqual(currencyCalculation.listedCurrencies["GBP"], 1.4)
        XCTAssertEqual(currencyCalculation.listedCurrencies["JPY"], 1.5)
    }

    func testGiven1EurosBuys128point62YEN_WhenGettingBaseRate_CallbackShouldReturnAStringWith128point62() {
        var rate = String()
        currencyCalculation.updateListedCurrencies(with: rates)
        currencyCalculation.listedCurrencies["JPY"] = 128.62

        currencyCalculation.getBaseRate(from: 1, toCurrency: 4) { returnedRate in
            rate = returnedRate
        }

        XCTAssertEqual(rate, "128.62")
    }

    func testGiven1EurosBuys0point84GBP_WhenConverting100EurToGBP_OutputStringShouldHaveAsValue84GBP() {
        currencyCalculation.updateListedCurrencies(with: rates)
        currencyCalculation.listedCurrencies["GBP"] = 0.84

        currencyCalculation.performConvert(from: 1, toCurrency: 3, with: "100")

        XCTAssertEqual(currencyCalculation.outputString, "84")
    }

    func testGivenUserAttemptsToConvertAnIncorrectString_WhenConverting_CalculationIsNotExecutedAndOutputStringValueShouldRemainAt0() {
        currencyCalculation.updateListedCurrencies(with: rates)
        currencyCalculation.listedCurrencies["GBP"] = 0.84

        currencyCalculation.performConvert(from: 1, toCurrency: 3, with: "jdiuhfk4")

        XCTAssertEqual(currencyCalculation.outputString, "0")

    }
}
