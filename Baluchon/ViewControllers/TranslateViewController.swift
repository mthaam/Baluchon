//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 5/11/21.
//

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
    }

    @IBAction func translate(_ sender: Any) {
        
    }

    @IBAction func switchLanguages(_ sender: Any) {
        reverseTranslationDirection()
    }

    
    @IBAction func enableLanguageDetection(_ sender: UISwitch) {
        autoDetectView(sender: sender)
    }
    
}

extension TranslateViewController {

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
