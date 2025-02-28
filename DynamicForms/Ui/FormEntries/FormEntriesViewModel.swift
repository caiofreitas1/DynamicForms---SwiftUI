//
//  FormEntriesViewModel.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import Foundation
import SwiftUI

class FormEntriesViewModel: ObservableObject {
    @Published var entries: [Entry] = []
    private let repository: FormRepository
    private let formId: String

    init(repository: FormRepository, formId: String) {
        self.repository = repository
        self.formId = formId
    }

    func loadEntries() {
        do {
            let result = try repository.getEntriesByFormId(formId: formId)
            self.entries = result
        } catch {
            print("Erro ao carregar entradas: \(error)")
        }
    }
}
