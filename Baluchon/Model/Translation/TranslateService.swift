//
//  TranslateService.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 12/11/21.
//
// swiftlint:disable line_length

import Foundation

/// This class is used to make calls to Google's cloud translate API
class TranslateService {

    static var shared = TranslateService()
    private init() {}

    private static var urlComponents = URLComponents()

    private static let key = "AIzaSyAqggqoDqInxikohkwtyPlw4x7sEe6Vgs4"

    private var task: URLSessionDataTask?
    private var translateSession = URLSession(configuration: .default)
    private var availableLanguagesSession = URLSession(configuration: .default)
    private var detectionSession = URLSession(configuration: .default)

    init(translateSession: URLSession, detectionSession: URLSession, availableLanguagesSession: URLSession) {
        self.translateSession = translateSession
        self.availableLanguagesSession = availableLanguagesSession
        self.detectionSession = detectionSession
    }

}

// MARK: - API CALLS

extension TranslateService {

    /// This function is the main function used to translate text.
    /// - Parameter from : a string value which is the input language name, e.g. "English"
    /// - Parameter toLang : a string value which is the target language code, e.g. "en"
    /// - Parameter autoDetect : a boolean which states if auto detecting input language is needed.
    /// - Parameter text : a string value, which is the actual text to translate.
    /// - Parameter callback : a closure that posts a boolean, and optional TranslatatedData and String objects.
    func translate(from: String, toLang: String, autoDetect: Bool, text: String, callback: @escaping (Bool, TranslatedData?, String?) -> Void) {
        setTranslateUrl(with: text, to: toLang)

        guard let url = TranslateService.urlComponents.url else {
            callback(false, nil, nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        task?.cancel()
        task = translateSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil, nil)
                    return
                }

                guard let responseJSON = try? JSONDecoder().decode(TranslationJsonToDecode.self, from: data) else {
                    callback(false, nil, nil)
                    return
                }
                let translatedData = self.parseJsonTranslationData(decodedJSON: responseJSON)
                if autoDetect == true {
                    let targetLanguage: String? = (toLang == "en") ? "English" : "French"
                    self.detectInputLanguage(text: text, target: targetLanguage) { _, detectedLanguage in
                        callback(true, translatedData, detectedLanguage)
                    }
                } else {
                    callback(true, translatedData, nil)
                }
            }
        }
        task?.resume()
    }

    /// This function calls the API to detect input language.
    /// - Note that another call is chained within dataTask().
    /// - Parameter text : a string value, which is the actual text to translate.
    /// - Parameter target : a string value which is the target language code, e.g. "English".
    /// - Parameter callback : a closure that posts a boolean, and optional String object.
    func detectInputLanguage(text: String, target: String?, callback: @escaping (Bool, String?) -> Void) {

        setDetectionUrl(with: text)

        guard let url = TranslateService.urlComponents.url else {
            callback(false, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        task?.cancel()

        task = detectionSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.manageDetectionSession(data: data, response: response, error: error, target: target) { success, detectedLanguage in
                    callback(success, detectedLanguage)
                }
            }
        }
        task?.resume()
    }

    /// This function calls the API to check support languages for translations's target language.
    /// - Parameter source : a string value, which is the actual text to translate.
    /// - Parameter target : a string value which is the target language code, e.g. "English".
    /// - Parameter callback : a closure that posts an optional String object, which is the confirmed language name detected.
    func checkAvailableLanguagesFor(source: String?, target: String?, callback: @escaping (String?) -> Void) {
        var outputLanguageCode = ""
        guard let target = target else {
            return
        }
        switch target {
        case "English":
            outputLanguageCode = "en"
        case "French":
            outputLanguageCode = "fr"
        default:
            break
        }

        setAvailableLanguagesUrl(for: outputLanguageCode)

        guard let url = TranslateService.urlComponents.url else {
            callback(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        task?.cancel()

        task = availableLanguagesSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.manageAvailableLanguagesSession(data: data, response: response, error: error, source: source) { confirmedLanguage in
                    callback(confirmedLanguage)
                }
            }
        }
        task?.resume()
    }

}

// MARK: - API CALLS SUPPORTING FUNCTIONS

extension TranslateService {

    /// This function comes in support to the detection API call.
    /// It refactors dataTask's closure body to make a smaller main function.
    private func manageDetectionSession(data: Data?, response: URLResponse?, error: Error?, target: String?, callback: @escaping (Bool, String?) -> Void) {
        guard let data = data, error == nil else {
            callback(false, nil)
            return
        }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            callback(false, nil)
            return
        }
        guard let responseJSON = try? JSONDecoder().decode(DetectionJsonToDecode.self, from: data) else {
            callback(false, nil)
            return
        }
        let detectedInput = self.parseJsonDetectionData(decodedJSON: responseJSON)
        self.checkAvailableLanguagesFor(source: detectedInput?.language, target: target) { detectedLanguage in
            guard detectedLanguage != nil else {
                callback(false, nil)
                return
            }
            callback(true, detectedLanguage)
        }
    }

    /// This function comes in support to the supported languages API call.
    /// It refactors dataTask's closure body to make a smaller main function.
    private func manageAvailableLanguagesSession(data: Data?, response: URLResponse?, error: Error?, source: String?, callback: (String?) -> Void) {
        guard let data = data, error == nil else {
            callback(nil)
            return
        }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            callback(nil)
            return
        }
        guard let responseJSON = try? JSONDecoder().decode(AvailableLanguages.self, from: data) else {
            callback(nil)
            return
        }
        let availableLanguages = self.parseLanguagesData(decodedJSON: responseJSON)
        guard let inputLangCode = source else { return }
        guard let language = availableLanguages?.languageDictionnary[inputLangCode] else {
            callback(nil)
            return
        }
        let confirmedLanguage: String? = language
        callback(confirmedLanguage)
    }

// MARK: - URL Setters

    /// This functions is used to set the URL of subsequent API request.
    /// - Parameter text : the string value received, which is the actual text to translate.
    /// - Parameter toLang : the string value which is a language code, e.g. "fr"
    private func setTranslateUrl(with text: String, to toLang: String) {
        TranslateService.urlComponents.scheme = "https"
        TranslateService.urlComponents.host = "translation.googleapis.com"
        TranslateService.urlComponents.path = "/language/translate/v2"
        TranslateService.urlComponents.queryItems = [
            URLQueryItem(name: "key", value: TranslateService.key),
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "target", value: toLang)
        ]
    }

    /// This functions is used to set the URL of subsequent API request.
    /// - Parameter text : the string value received, which is the actual text to translate.
    private func setDetectionUrl(with text: String) {
        TranslateService.urlComponents.scheme = "https"
        TranslateService.urlComponents.host = "translation.googleapis.com"
        TranslateService.urlComponents.path = "/language/translate/v2/detect"
        TranslateService.urlComponents.queryItems = [
            URLQueryItem(name: "key", value: TranslateService.key),
            URLQueryItem(name: "q", value: text)
        ]
    }

    /// This functions is used to set the URL of subsequent API request.
    /// - Parameter outputLanguageCode : the string value which is a language code, e.g. "fr"
    private func setAvailableLanguagesUrl(for outputLanguageCode: String) {
        TranslateService.urlComponents.scheme = "https"
        TranslateService.urlComponents.host = "translation.googleapis.com"
        TranslateService.urlComponents.path = "/language/translate/v2/languages"
        TranslateService.urlComponents.queryItems = [
            URLQueryItem(name: "key", value: TranslateService.key),
            URLQueryItem(name: "target", value: outputLanguageCode)
        ]
    }

}

// MARK: - JSON PARSING FUNCTIONS

extension TranslateService {

    /// This function parses a decoded AvailableLanguages.
    /// It returns an optionnal LanguageDictionnary object.
    /// - Parameter decodedJson : An AvailableLanguages object, which contains all the datas
    ///  decoded from the JSON data received.
    private func parseLanguagesData(decodedJSON: AvailableLanguages) -> LanguageDictionnary? {
        var dictionnary: [String: String] = [String: String]()
        for languageEntry in decodedJSON.data.languages {
            dictionnary[languageEntry.language] = languageEntry.name
        }
        let languageDictionnary = LanguageDictionnary(languageDictionnary: dictionnary)
        return languageDictionnary
    }

    /// This function parses a decoded DetectionJsonToDecode.
    /// It returns an optionnal DetectionLanguage object.
    /// - Parameter decodedJson : An AvailableLanguages object, which contains all the datas
    ///  decoded from the JSON data received.
    private func parseJsonDetectionData(decodedJSON: DetectionJsonToDecode ) -> DetectionLanguage? {
        guard let detectedLanguage = decodedJSON.data.detections[0][0].language else {
            let language = DetectionLanguage(language: "Could not detect")
            return language }
        let language = DetectionLanguage(language: detectedLanguage )
        return language
    }

    /// This function parses a decoded TranslationJsonToDecode.
    /// It returns a TranslatedData object.
    /// - Parameter decodedJson : A TranslationJsonToDecode object, which contains all the datas
    ///  decoded from the JSON data received.
    private func parseJsonTranslationData(decodedJSON: TranslationJsonToDecode ) -> TranslatedData {
        var text = String()
        var language = String()

        for translationOccurence in decodedJSON.data.translations {
            if let translation = translationOccurence.translatedText {
                text.append(translation)
            }
        }

        if let detectedLanguage = decodedJSON.data.translations[0].detectedLanguageSource {
            language = detectedLanguage
        }

        let translatedData = TranslatedData(text: text, target: language)
        return translatedData
    }

}
