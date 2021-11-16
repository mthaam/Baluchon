//
//  CurrencyModel.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 15/11/21.
//

import Foundation

class CurrencyTreatment {

    private var listedCurrencies: [String: Double] = [:]

    var outputString: String = "0" {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateDisplay"),
                                            object: nil, userInfo: ["updateDisplay": outputString])
        }
    }

    func updateListedCurrencies(with rates: Rates?) {
//        guard let allRatesInfo = rates, let rates = allRatesInfo.rates else {
//            print("could not update rates")
//            return
//        }
        guard let allRatesInfo = rates else { return }
        guard let rates = allRatesInfo.rates else { return }
        listedCurrencies["USD"] = rates.USD
        listedCurrencies["EUR"] = Double(rates.EUR)
        listedCurrencies["CAD"] = rates.CAD
        listedCurrencies["GBP"] = rates.GBP
        listedCurrencies["JPY"] = rates.JPY
    }

    func performConvert(from inputIndex: Int, toCurrency outputIndex: Int, with number: String) {
        let inputCurrencyRate = getInputOutputRates(withIndex: inputIndex)
        let outputCurencyRate = getInputOutputRates(withIndex: outputIndex)
        guard let doubleToConvert = Double(number) else {
            sendAlertNotification(message: "Unable to convert input")
            return }
        let euroConverted = convertToEuros(with: doubleToConvert, from: inputCurrencyRate)
        let finalOutputConverted = convertToFinalOutput(with: euroConverted, toOutput: outputCurencyRate)
        let convertedOutput = doubleToString(from: finalOutputConverted)
//        let baseRate = calculateBaseRate(from: inputCurrencyRate, to: outputCurencyRate)
//        let entireString = "\(convertedOutput)"
        outputString = convertedOutput
    }

//    func clear() {
//        inputString = "0"
//        firstConvert = true
//    }

    private func calculateBaseRate(from inputRate: Double, to outputRate: Double) -> String {
        var rateString = ""
        let base = convertToEuros(with: 1.0, from: inputRate)
        let finalRate = convertToFinalOutput(with: base, toOutput: outputRate)
        let finalRateAsString = doubleToString(from: finalRate)
        rateString = finalRateAsString
        return rateString
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
        switch withIndex {
        case 0 :
            if let usd = listedCurrencies["USD"] { rate = usd }
        case 1 :
            if let eur = listedCurrencies["EUR"] { rate = eur }
        case 2 :
            if let cad = listedCurrencies["CAD"] { rate = cad }
        case 3 :
            if let gpb = listedCurrencies["GBP"] { rate = gpb }
        case 4 :
            if let jpy = listedCurrencies["JPY"] { rate = jpy }
        default :
            break
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
