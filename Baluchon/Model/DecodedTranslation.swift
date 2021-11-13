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
