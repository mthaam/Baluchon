//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 5/11/21.
//
// swiftlint:disable line_length

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak var leftLanguageLabel: UILabel!
    @IBOutlet weak var englishLanguageLabel: UILabel!
    @IBOutlet weak var toTranslateTextView: UITextView!
    @IBOutlet weak var autoDetectSwitch: UISwitch!
    @IBOutlet weak var translatedTextView: UITextView!

    @IBOutlet weak var languagesStackView: UIStackView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var inputTextView: UIView!
    @IBOutlet weak var leftLanguageView: UIView!
    @IBOutlet weak var rightLanguageView: UIView!
    @IBOutlet weak var autoDetectView: UIView!
    @IBOutlet weak var switchLanguagesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeRoundCornersToViews()
        toggleActivityIndicator(shown: false)
        toTranslateTextView.delegate = self
        toTranslateTextView.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toTranslateTextView.becomeFirstResponder()
    }

    @IBAction func translate(_ sender: Any) {
        performLanguageTranslatation(from: leftLanguageLabel.text, toLang: englishLanguageLabel.text, autoDetect: autoDetectSwitch.isOn)
    }

    @IBAction func switchLanguages(_ sender: Any) {
        reverseTranslationDirection()
    }

    @IBAction func enableLanguageDetection(_ sender: UISwitch) {
        guard toTranslateTextView.hasText && toTranslateTextView.text.components(separatedBy: " ").count > 3 else {
            sender.setOn(false, animated: true)
            sendAlert(withMessage: "Type in at least 4 words to enable Auto Detection")
            return
        }
        autoDetectView(sender: sender)
        if sender.isOn {
            performDetection()
        } else {
            leftLanguageLabel.text = "French"
            englishLanguageLabel.text = "English"
        }
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        toTranslateTextView.resignFirstResponder()
    }

}

// MARK: - API CALLS MANAGEMENT

extension TranslateViewController {

    /// This function calls translate method from TranslateService.
    /// - Parameter from : A String? value which is the source language.
    /// - Parameter toLang: A String? value which is the target translation language.
    /// - Parameter autoDetect : a boolean value, which is the current
    /// autoDetect UISwitch.isOn value.
    private func performLanguageTranslatation(from: String?, toLang: String?, autoDetect: Bool) {
        guard let inputLanguage = from, let outputLanguage = toLang else { return }
        guard let text = toTranslateTextView.text else { return }
        var outputLanguageCode = String()
        toggleActivityIndicator(shown: true)
        switch outputLanguage {
        case "English":
            outputLanguageCode = "en"
        case "French" :
            outputLanguageCode = "fr"
        default:
            break
        }

        TranslateService.shared.translate(from: inputLanguage, toLang: outputLanguageCode, autoDetect: autoDetect, text: text) { success, translatedContent, detectedLanguage in
            if success {
                self.toggleActivityIndicator(shown: false)
                guard let translatedContent = translatedContent else {
                    return
                }
                if detectedLanguage != nil {
                    self.leftLanguageLabel.text = detectedLanguage
                }
                self.translatedTextView.text = translatedContent.text
            } else {
                self.toggleActivityIndicator(shown: false)
                self.sendAlert(withMessage: "Unable to translate.")
            }
        }
    }

    /// This function calls the  detection method from TranslateService.
    private func performDetection() {
        guard let text = toTranslateTextView.text else { return }
        toggleActivityIndicator(shown: true)
        TranslateService.shared.detectInputLanguage(text: text, target: englishLanguageLabel.text) { success, detectedLanguage in
            if success {
                self.toggleActivityIndicator(shown: false)
                guard let detection = detectedLanguage else { return }
                self.leftLanguageLabel.text = detection
            } else {
                self.toggleActivityIndicator(shown: false)
                self.sendAlert(withMessage: "Could not succeed to detect language.")
            }
        }
    }

    /// This function calls the presentAlert() function
    /// - Parameter withMessage : A string value, which
    /// is the message displayed in case of an Alert.
    private func sendAlert(withMessage: String) {
        presentAlert(withMessage: withMessage)
    }

    /// This function displays an alert to user.
    /// - Parameter withMessage : A string value, which
    /// is the message displayed in case of an Alert.
    private func presentAlert(withMessage: String) {
        let alertViewController = UIAlertController(title: "Warning", message: withMessage, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }

}

// MARK: - DISPLAY MANAGEMENT FUNCTIONS

extension TranslateViewController {

    /// This function updates Language labels
    private func autoDetectView(sender: UISwitch) {
        switch sender.isOn {
        case true :
            leftLanguageLabel.text = "Auto detecting"
        case false :
            leftLanguageLabel.text = "French"
        }
    }

    /// This function updates Languages names in case
    /// user reverses translation direction.
    private func reverseTranslationDirection() {
        guard autoDetectSwitch.isOn == false else {
            sendAlert(withMessage: "Turn off auto detection before switching languages.")
            return }
        var languages: [String?] {
            [leftLanguageLabel.text, englishLanguageLabel.text] }
        guard let leftLanguage = languages[0], let rightLanguage = languages[1] else { return }
        englishLanguageLabel.text = leftLanguage
        leftLanguageLabel.text = rightLanguage
    }

    /// This function makes round corners to views.
    private func makeRoundCornersToViews() {
        bottomView.layer.cornerRadius = 10
        inputTextView.layer.cornerRadius = 10
        leftLanguageView.layer.cornerRadius = 10
        rightLanguageView.layer.cornerRadius = 10
        autoDetectView.layer.cornerRadius = 10
        autoDetectSwitch.layer.cornerRadius = 12
    }

    /// This function toggles activity indicator.
    private func toggleActivityIndicator(shown: Bool) {
        switchLanguagesButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
}

// MARK: - UITEXTVIEW DELEGATE

extension TranslateViewController: UITextViewDelegate {

    /// This function is used to manage keyboard disapperance,
    /// and calls Language translation if user presses "GO"
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            toTranslateTextView.resignFirstResponder()
            performLanguageTranslatation(from: leftLanguageLabel.text, toLang: englishLanguageLabel.text, autoDetect: autoDetectSwitch.isOn)
            return false
        }
        return true
    }
}
