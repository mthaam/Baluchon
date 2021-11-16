//
//  CurrencyExchangeViewController.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 5/11/21.
//

import UIKit

class CurrencyExchangeViewController: UIViewController {

    let currencyTreatment = CurrencyTreatment()

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var containingViewPicker: UIView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeRoundCornersToViews()
        getRates()

        NotificationCenter.default.addObserver(self, selector: #selector(displayResult(notification:)),
                                               name: Notification.Name("updateDisplay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(displayAlert(notification:)),
                                               name: Notification.Name("alertDisplay"), object: nil)
    }

    @IBAction func convert(_ sender: Any) {
        performConverting()
    }
}

extension CurrencyExchangeViewController {

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

extension CurrencyExchangeViewController {

    private func performConverting() {
        let inputPickerIndex = pickerView.selectedRow(inComponent: 0), outputPickerIndex = pickerView.selectedRow(inComponent: 1)
        currencyTreatment.performConvert(from: inputPickerIndex, toCurrency: outputPickerIndex, with: inputTextView.text)
    }

    private func getRates() {
        CurrencyService.shared.getRates { success, rates in
            if success {
                self.currencyTreatment.updateListedCurrencies(with: rates)
            } else {
                self.presentAlert(withMessage: "Unable to retrieve latests rates.")
            }
        }
    }

    private func presentAlert(withMessage: String) {
        let alertViewController = UIAlertController(title: "Warning", message: withMessage, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }

}

extension CurrencyExchangeViewController {

    private func makeRoundCornersToViews() {
        inputTextView.layer.cornerRadius = 10
        outputTextView.layer.cornerRadius = 10
        containingViewPicker.layer.cornerRadius = 10
    }

}

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

}

extension CurrencyExchangeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
                    inputTextView.resignFirstResponder()
                    return false
                }
        return true
    }

}
