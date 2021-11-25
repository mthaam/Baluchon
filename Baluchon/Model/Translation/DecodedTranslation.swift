//
//  CodedDecodedTranslation.swift
//  Baluchon
//
//  Created by SEBASTIEN BRUNET on 13/11/2021.

import Foundation

/// This strurcture matches the objects received from call in JSON data for translation
/// It conforms to Decodable protocol
struct TranslationJsonToDecode: Decodable {
    var data: JsonContent
}
/// This structure is part of main decoded structure for translation
/// It conforms to Decodable protocol
struct JsonContent: Decodable {
    var translations: [TranslationContent]
}
/// This structure is part of main decoded structure for translation
/// It conforms to Decodable protocol
struct TranslationContent: Decodable {
    var translatedText, detectedLanguageSource: String?
}
/// This structure contains all the necessary
/// data to update UI text view
struct TranslatedData {
    var text: String
    var target: String
}
/// This strurcture matches the objects received from call in JSON data for detection
/// It conforms to Decodable protocol
struct DetectionJsonToDecode: Decodable {
    var data: DetectionJsonContent
}
/// This structure is part of main decoded structure for detection
/// It conforms to Decodable protocol
struct DetectionJsonContent: Decodable {
    var detections: [[DetectionContent]]
}
/// This structure is part of main decoded structure for detection
/// It conforms to Decodable protocol
struct DetectionContent: Decodable {
    var language: String?
}
/// This structure contains all the necessary
/// data to update UI text view
struct DetectionLanguage {
    let language: String
}
/// This strurcture matches the objects received from call in JSON data for supported languages
/// It conforms to Decodable protocol
struct AvailableLanguages: Decodable {
    var data: Languages
}
/// This structure is part of main decoded structure for supported languages
/// It conforms to Decodable protocol
struct Languages: Decodable {
    var languages: [LanguageEntries]
}
/// This structure is part of main decoded structure for supported languages
/// It conforms to Decodable protocol
struct LanguageEntries: Decodable {
    var language, name: String
}
/// This structure contains all the support languages
///  for a given language.
///  It is used as Key = Language code, and value = Language name
struct LanguageDictionnary {
    var languageDictionnary: [String: String]
}
