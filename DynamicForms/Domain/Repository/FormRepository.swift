//
//  FormRepository.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import Foundation

protocol FormRepository {
    func insertFormFromDto(formId: String, formDto: FormDto) throws
    func getAllForms() throws -> [Form]
    func getFormContents(formId: String) throws -> (Form, [Section], [Field])?
    func getEntriesByFormId(formId: String) throws -> [Entry]
    func saveEntry(formId: String, entryId: String, fieldValues: [String: String]) throws
}
