//
//  CodedDecodedTranslation.swift
//  Baluchon
//
//  Created by SEBASTIEN BRUNET on 13/11/2021.

import Foundation

struct TranslationJsonToDecode: Decodable {
    var data: JsonContent
}

struct JsonContent: Decodable {
    var translations: [TranslationContent]
}

struct TranslationContent: Decodable {
    var translatedText, detectedLanguageSource: String?
}

struct TranslatedData {
    var text: String
    var target: String
}

struct DetectionJsonToDecode: Decodable {
    var data: DetectionJsonContent
}

struct DetectionJsonContent: Decodable {
    var detections: [[DetectionContent]]
}

struct DetectionContent: Decodable {
    var language: String?
}

struct DetectionLanguage {
    let language: String
}

struct AvailableLanguages: Decodable {
    var data: Languages
}

struct Languages: Decodable {
    var languages: [LanguageEntries]
}

struct LanguageEntries: Decodable {
    var language, name: String
}

struct LanguageDictionnary {
    var languageDictionnary: [String: String]
}
