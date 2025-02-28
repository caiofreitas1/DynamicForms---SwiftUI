//
//  Field.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import Foundation

struct Field {
    let fieldId: String
    let parentFormId: String
    let type: String
    let label: String
    let name: String
    let required: Bool
    let orderIndex: Int
    let options: [Option]
}
