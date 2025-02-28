//
//  FormListViewModel.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import Foundation
import SwiftUI

class FormListViewModel: ObservableObject {
    @Published var forms: [Form] = []
    private let repository: FormRepository

    private let formsLoadedKey = "forms_loaded"

    init(repository: FormRepository) {
        self.repository = repository
    }

    func loadAndInsertFormsIfNeeded() {
        let alreadyLoaded = UserDefaults.standard.bool(forKey: formsLoadedKey)
        if alreadyLoaded {
            loadForms()
            return
        }

        do {
            if let path1 = Bundle.main.path(forResource: "all-fields", ofType: "json"),
               let data1 = try? Data(contentsOf: URL(fileURLWithPath: path1)),
               let formDto1 = try? JSONDecoder().decode(FormDto.self, from: data1) {
                try repository.insertFormFromDto(formId: "all-fields", formDto: formDto1)
            }

            if let path2 = Bundle.main.path(forResource: "200-form", ofType: "json"),
               let data2 = try? Data(contentsOf: URL(fileURLWithPath: path2)),
               let formDto2 = try? JSONDecoder().decode(FormDto.self, from: data2) {
                try repository.insertFormFromDto(formId: "200-form", formDto: formDto2)
            }

            UserDefaults.standard.set(true, forKey: formsLoadedKey)

            loadForms()

        } catch {
            print("Erro ao inserir forms: \(error)")
        }
    }

    func loadForms() {
        do {
            let list = try repository.getAllForms()
            self.forms = list
        } catch {
            print("Erro ao carregar forms: \(error)")
        }
    }
}
