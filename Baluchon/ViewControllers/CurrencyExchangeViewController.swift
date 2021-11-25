//
//  CurrencyExchangeViewController.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 5/11/21.
//
// swiftlint:disable line_length

import UIKit

class CurrencyExchangeViewController: UIViewController {

    var inputPickerIndex: Int { pickerView.selectedRow(inComponent: 0) }
    var outputPickerIndex: Int { pickerView.selectedRow(inComponent: 1) }

    let currencyTreatment = CurrencyTreatment()

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var containingViewPicker: UIView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    @IBOutlet weak var baseAndUpdateStackView: UIStackView!
    @IBOutlet weak var baseRateLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var textViewContainer: UIView!
    @IBOutlet weak var upperSymboLabel: UILabel!
    @IBOutlet weak var bottomSymbolLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeRoundCornersToViews()
        inputTextView.delegate = self
        inputTextView.becomeFirstResponder()

        NotificationCenter.default.addObserver(self, selector: #selector(displayResult(notification:)),
                                               name: Notification.Name("updateDisplay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)),
                                               name: Notification.Name("alertDisplay"), object: nil)
        getCurrencySymbol(from: inputPickerIndex, for: upperSymboLabel)
        getCurrencySymbol(from: outputPickerIndex, for: bottomSymbolLabel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateCurrencies()
        inputTextView.becomeFirstResponder()
    }

    @IBAction func convert(_ sender: Any) {
        performConverting()
    }

    @IBAction func clear(_ sender: Any) {
        clearLabels()
    }
    @IBAction func dismissKeyboard(_ sender: Any) {
        inputTextView.resignFirstResponder()
    }

}

// MARK: - @OBJc FUNCTIONS

extension CurrencyExchangeViewController {

    /// This function updates result label whenever a notification is received
    @objc func displayResult(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        outputTextView.text = userInfo["updateDisplay"] as? String
    }

    /// This function displays alerts if a notification is received.
    @objc func displayAlert(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let errorMessage = userInfo["message"] as? String else { return }
        presentAlert(withMessage: errorMessage)
    }

}

// MARK: - CALCULATIONS AND API CALLS

extension CurrencyExchangeViewController {

    /// This function calls the getRates() function
    /// if rates were not updated for more than 24hrs.
    private func updateCurrencies() {
        let now = Date()
        guard let lastTimeString = lastUpdateLabel.text else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd"
        dateFormatter.timeZone = .current
        let lastUpdateTime = dateFormatter.date(from: lastTimeString)
        guard let lastTime = lastUpdateTime else { return }
        let timeIntervalSinceUpdate = Int(now.timeIntervalSince(lastTime))
        if timeIntervalSinceUpdate >= 86400 {
            getRates()
        }
    }

    /// This function calls performConvert() and
    /// getBaseRate() from currencyModel.
    private func performConverting() {
        currencyTreatment.performConvert(from: inputPickerIndex, toCurrency: outputPickerIndex, with: inputTextView.text)
        currencyTreatment.getBaseRate(from: inputPickerIndex, toCurrency: outputPickerIndex) { baseRate in
            baseRateLabel.text = "1 \(currencies[inputPickerIndex]) = \(baseRate) \(currencies[outputPickerIndex])"
        }
        inputTextView.resignFirstResponder()
    }

    /// This funciton calls the getRates() function from
    /// CurrencyService class, to fetch rates.
    private func getRates() {
        CurrencyService.shared.getRates { success, rates in
            if success {
                self.currencyTreatment.updateListedCurrencies(with: rates)
                if let date = rates?.date {
                    self.lastUpdateLabel.text = date
                }
                self.currencyTreatment.getBaseRate(from: self.inputPickerIndex, toCurrency: self.outputPickerIndex) { baseRate in
                    self.baseRateLabel.text = "1 \(currencies[self.inputPickerIndex]) = \(baseRate) \(currencies[self.outputPickerIndex])"
                }
            } else {
                self.presentAlert(withMessage: "Unable to retrieve latests rates.")
            }
        }
    }

    /// THis function clears labels.
    private func clearLabels() {
        inputTextView.text = ""
        currencyTreatment.clear()
    }

    /// This function displays an alert if needed.
    /// - Parameter withMessage : a string value,
    /// which is the message to display.
    private func presentAlert(withMessage: String) {
        let alertViewController = UIAlertController(title: "Warning", message: withMessage, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }

    /// THis function updates currency symbols.
    private func getCurrencySymbol(from row: Int, for label: UILabel!) {
        for (key, value) in currenciesIndexes where value == row {
            if let currencySymbol = currenciesSymbols["\(key)"] {
                if let currencyFlag = currenciesFlags["\(key)"] {
                    label.text = "\(currencySymbol)\n\(currencyFlag)"
                }
            }
        }
    }

}

// MARK: - DISPLAY MANAGEMENT FUNCTIONS

extension CurrencyExchangeViewController {

    /// This function makes round corners to views.
    private func makeRoundCornersToViews() {
        upperSymboLabel.layer.masksToBounds = true
        upperSymboLabel.layer.cornerRadius = 10
        bottomSymbolLabel.layer.masksToBounds = true
        bottomSymbolLabel.layer.cornerRadius = 10
        textViewContainer.layer.cornerRadius = 10
        outputTextView.layer.cornerRadius = 10
        containingViewPicker.layer.cornerRadius = 10
        baseAndUpdateStackView.layer.cornerRadius = 10
        bottomStackView.layer.cornerRadius = 10
    }

}

// MARK: - PICKER VIEW DELEGATES

extension CurrencyExchangeViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return currencies[row]
        } else {
            return currencies[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            getCurrencySymbol(from: row, for: upperSymboLabel)
        } else {
            getCurrencySymbol(from: row, for: bottomSymbolLabel)
        }
        if inputTextView.text.count >= 1 {
            performConverting()
        }
    }
}

// MARK: - UITEXTVIEW DELEGATE

extension CurrencyExchangeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
                    inputTextView.resignFirstResponder()
                    return false
                }
        return true
    }

}
