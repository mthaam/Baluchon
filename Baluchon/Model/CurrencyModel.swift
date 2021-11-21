//
//  CurrencyModel.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 15/11/21.
//

import Foundation

final class CurrencyTreatment {

    var listedCurrencies: [String: Double] = [:]
    private var indexes = currenciesIndexes

    var outputString: String = "0" {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateDisplay"),
                                            object: nil, userInfo: ["updateDisplay": outputString])
        }
    }

    func updateListedCurrencies(with rates: Rates?) {
        guard let allRatesInfo = rates else { return }
        guard let rates = allRatesInfo.rates else { return }
        listedCurrencies["USD"] = rates.USD
        listedCurrencies["EUR"] = Double(rates.EUR)
        listedCurrencies["CAD"] = rates.CAD
        listedCurrencies["GBP"] = rates.GBP
        listedCurrencies["JPY"] = rates.JPY
    }

    func getBaseRate(from inputIndex: Int, toCurrency outputIndex: Int, callback: (String) -> Void) {
        let inputCurrencyRate = getInputOutputRates(withIndex: inputIndex)
        let outputCurencyRate = getInputOutputRates(withIndex: outputIndex)
        let euroConverted = convertToEuros(with: 1.0, from: inputCurrencyRate)
        let finalOutputConverted = convertToFinalOutput(with: euroConverted, toOutput: outputCurencyRate)
        let convertedOutput = doubleToString(from: finalOutputConverted)
        callback(convertedOutput)
    }

    func performConvert(from inputIndex: Int, toCurrency outputIndex: Int, with number: String) {
        let inputCurrencyRate = getInputOutputRates(withIndex: inputIndex)
        let outputCurencyRate = getInputOutputRates(withIndex: outputIndex)
        guard let doubleToConvert = Double(number) else {
            sendAlertNotification(message: "Unable to convert input.")
            return }
        let euroConverted = convertToEuros(with: doubleToConvert, from: inputCurrencyRate)
        let finalOutputConverted = convertToFinalOutput(with: euroConverted, toOutput: outputCurencyRate)
        let convertedOutput = doubleToString(from: finalOutputConverted)
        outputString = convertedOutput
    }

    func clear() {
        outputString = "0"
    }

    private func convertToEuros(with input: Double, from rate: Double) -> Double {
        var converted = 0.0
        converted = input / rate
        return converted
    }

    private func convertToFinalOutput(with input: Double, toOutput: Double) -> Double {
        var converted = 0.0
        converted = input * toOutput
        return converted
    }

    private func getInputOutputRates(withIndex: Int) -> Double {
        var rate = 0.0
        for (key, value) in indexes where value == withIndex {
            if let currencyRate = listedCurrencies["\(key)"] {
                rate = currencyRate
            }
        }
        return rate
    }

    private func doubleToString(from currentResult: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.maximumFractionDigits = 2
        let doubleAsString =  formatter.string(from: NSNumber(value: currentResult))!
        return doubleAsString
    }

    private func sendAlertNotification(message: String) {
        let name = Notification.Name("alertDisplay")
        NotificationCenter.default.post(name: name, object: nil, userInfo: ["message": message])
    }

}
