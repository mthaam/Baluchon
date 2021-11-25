//
//  CurrencyModel.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 15/11/21.
//

import Foundation

/// This class is used to perform calculations
/// based on exchange rates received from Fixer.io API.
final class CurrencyTreatment {

    var listedCurrencies: [String: Double] = [:]
    private var indexes = currenciesIndexes

    var outputString: String = "0" {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("updateDisplay"),
                                            object: nil, userInfo: ["updateDisplay": outputString])
        }
    }

    /// This function is used insert elements in listedCurrencies dictionnary,
    /// based on received rates from API.
    /// - Parameter rates : An optionnal Rates object received after API call.
    func updateListedCurrencies(with rates: Rates?) {
        guard let allRatesInfo = rates else { return }
        guard let rates = allRatesInfo.rates else { return }
        listedCurrencies["USD"] = rates.USD
        listedCurrencies["EUR"] = Double(rates.EUR)
        listedCurrencies["CAD"] = rates.CAD
        listedCurrencies["GBP"] = rates.GBP
        listedCurrencies["JPY"] = rates.JPY
    }

    /// This function is used to calculate a base rate,
    /// e.g. USD1 = GPB x.x.
    /// - Parameter inputIndex : An Int value, which is the
    /// current index of UIPickerView in a given row.
    /// - Parameter outputIndex : An Int value, which is the
    /// current index of UIPickerView in a given row.
    /// - Parameter callback : a closure that posts a string value, which
    /// is a given base rate.
    func getBaseRate(from inputIndex: Int, toCurrency outputIndex: Int, callback: (String) -> Void) {
        let inputCurrencyRate = getInputOutputRates(withIndex: inputIndex)
        let outputCurencyRate = getInputOutputRates(withIndex: outputIndex)
        let euroConverted = convertToEuros(with: 1.0, from: inputCurrencyRate)
        let finalOutputConverted = convertToFinalOutput(with: euroConverted, toOutput: outputCurencyRate)
        let convertedOutput = doubleToString(from: finalOutputConverted)
        callback(convertedOutput)
    }

    /// This function is used to calculate any number into a target currency.
    /// - Parameter inputIndex : An Int value, which is the
    /// current index of UIPickerView in a given row.
    /// - Parameter toCurrency : An Int value, which is the
    /// current index of UIPickerView in a given row.
    /// - Parameter number : a string value, which is the number to convert
    /// into another currency.
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

    /// This function clears the output string computed
    /// property.
    func clear() {
        outputString = "0"
    }

    /// This function converts to Euros a given value, and returns this
    /// value as a Double.
    /// - Parameter input : the Double value to convert
    /// - Parameter rate : the rate used to convert to euros.
    private func convertToEuros(with input: Double, from rate: Double) -> Double {
        var converted = 0.0
        converted = input / rate
        return converted
    }

    /// This function converts to target currency a given value, and returns this
    /// value as a Double.
    /// - Parameter input : the Double value to convert
    /// - Parameter toOutput : the rate used to convert to target currency.
    private func convertToFinalOutput(with input: Double, toOutput: Double) -> Double {
        var converted = 0.0
        converted = input * toOutput
        return converted
    }

    /// This function returns a double value, which is
    /// either the input rate, or the target currency rate.
    /// - Parameter withIndex : an Int value, which is
    /// the current Index of PickerView.
    private func getInputOutputRates(withIndex: Int) -> Double {
        var rate = 0.0
        for (key, value) in indexes where value == withIndex {
            if let currencyRate = listedCurrencies["\(key)"] {
                rate = currencyRate
            }
        }
        return rate
    }

    /// This function returns a String value.
    /// - Parameter currentResult : A double value
    /// which is the converted value to display to user.
    private func doubleToString(from currentResult: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.maximumFractionDigits = 2
        let doubleAsString =  formatter.string(from: NSNumber(value: currentResult))!
        return doubleAsString
    }

    /// This function sends a notification to controller.
    /// - Parameter message : A string value which is
    /// the alert message we want to display to user.
    private func sendAlertNotification(message: String) {
        let name = Notification.Name("alertDisplay")
        NotificationCenter.default.post(name: name, object: nil, userInfo: ["message": message])
    }

}
