//
//  CurrencyExchangeViewController.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 5/11/21.
//

import UIKit

class CurrencyExchangeViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var containingViewPicker: UIView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeRoundCornersToViews()
    }

    @IBAction func convert(_ sender: Any) {
        performConverting()
    }
}

extension CurrencyExchangeViewController {

    private func performConverting() {
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
        return nil
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
