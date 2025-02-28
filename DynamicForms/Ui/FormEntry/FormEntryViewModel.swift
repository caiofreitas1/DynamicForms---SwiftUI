//
//  FormEntryViewModel.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import Foundation
import SwiftUI

class FormEntryViewModel: ObservableObject {
    @Published var form: Form?
    @Published var sections: [Section] = []
    @Published var fields: [Field] = []
    @Published var fieldValues: [String: String] = [:]

    private let repository: FormRepository
    private let formId: String

    private var timer: Timer?

    init(repository: FormRepository, formId: String) {
        self.repository = repository
        self.formId = formId
    }

    func loadForm() {
        do {
            if let (form, sec, flds) = try repository.getFormContents(formId: formId) {
                self.form = form
                self.sections = sec.sorted { $0.index < $1.index }
                self.fields = flds.sorted { $0.orderIndex < $1.orderIndex }
            }
        } catch {
            print("Erro ao carregar formulário: \(error)")
        }
    }

    func updateFieldValue(fieldId: String, newValue: String) {
        fieldValues[fieldId] = newValue
    }

    func saveEntry(completion: @escaping () -> Void) {
        do {
            let entryId = UUID().uuidString
            try repository.saveEntry(formId: formId, entryId: entryId, fieldValues: fieldValues)
        } catch {
            print("Erro ao salvar entry: \(error)")
        }
        completion()
    }
    
    func fields(in section: Section) -> [Field] {
        fields.filter {
            $0.orderIndex >= section.fromIndex && $0.orderIndex <= section.toIndex
        }.sorted { $0.orderIndex < $1.orderIndex }
    }

}
