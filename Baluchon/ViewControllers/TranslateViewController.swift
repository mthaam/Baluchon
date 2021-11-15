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

    override func viewDidLoad() {
        super.viewDidLoad()
        makeRoundCornersToViews()
        toTranslateTextView.delegate = self
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

}

extension TranslateViewController {

    private func performLanguageTranslatation(from: String?, toLang: String?, autoDetect: Bool) {
        guard let inputLanguage = from, let outputLanguage = toLang else { return }
        guard let text = toTranslateTextView.text else { return }
        var outputLanguageCode = String()

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
                guard let translatedContent = translatedContent else {
                    return
                }
                if detectedLanguage != nil {
                    self.leftLanguageLabel.text = detectedLanguage
                }
                self.translatedTextView.text = translatedContent.text
            } else {
                self.sendAlert(withMessage: "Unable to translate")
            }
        }
    }

    private func performDetection() {
        guard let text = toTranslateTextView.text else { return }
        TranslateService.shared.detectInputLanguage(text: text, target: englishLanguageLabel.text) { success, detectedLanguage in
            if success {
                guard let detection = detectedLanguage else { return }
                self.leftLanguageLabel.text = detection
            } else {
                self.sendAlert(withMessage: "Could not succeed to detect language")
            }
        }
    }

    private func sendAlert(withMessage: String) {
        presentAlert(withMessage: withMessage)
    }

    private func presentAlert(withMessage: String) {
        let alertViewController = UIAlertController(title: "Warning", message: withMessage, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }

}

extension TranslateViewController {

    private func autoDetectView(sender: UISwitch) {
        switch sender.isOn {
        case true :
            leftLanguageLabel.text = "Auto detecting"
        case false :
            leftLanguageLabel.text = "French"
        }
    }

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

    private func makeRoundCornersToViews() {
        bottomView.layer.cornerRadius = 10
        inputTextView.layer.cornerRadius = 10
        leftLanguageView.layer.cornerRadius = 10
        rightLanguageView.layer.cornerRadius = 10
        autoDetectView.layer.cornerRadius = 10
        autoDetectSwitch.layer.cornerRadius = 12
    }
}

extension TranslateViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
                    toTranslateTextView.resignFirstResponder()
                    return false
                }
        return true
    }
}
