//
//  FormDto.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import Foundation

struct FormDto: Decodable {
    let title: String
    let fields: [FieldDto]
    let sections: [SectionDto]
}

struct FieldDto: Decodable {
    let type: String
    let label: String
    let name: String
    let required: Bool?
    let uuid: String
    let options: [OptionDto]?
}

struct OptionDto: Decodable {
    let label: String
    let value: String
}

struct SectionDto: Decodable {
    let title: String
    let from: Int
    let to: Int
    let index: Int
    let uuid: String
}
