//
//  FormJsonParser.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import Foundation

struct FormJsonParser {
    static func parseFieldValues(_ json: String) -> [String: String] {
        guard let data = json.data(using: .utf8) else { return [:] }
        do {
            return try JSONDecoder().decode([String: String].self, from: data)
        } catch {
            return [:]
        }
    }

    static func mapToJson(_ map: [String: String]) -> String {
        do {
            let data = try JSONEncoder().encode(map)
            return String(data: data, encoding: .utf8) ?? "{}"
        } catch {
            return "{}"
        }
    }
}
