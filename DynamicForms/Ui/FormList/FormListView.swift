//
//  FormListView.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import SwiftUI

struct FormListView: View {
    @StateObject private var viewModel: FormListViewModel

    init() {
        let context = PersistenceController.shared.container.viewContext
        let dataSource = FormLocalDataSourceImpl(context: context)
        let repo = FormRepositoryImpl(localDataSource: dataSource)
        _viewModel = StateObject(wrappedValue: FormListViewModel(repository: repo))
    }

    var body: some View {
        NavigationView {
            List(viewModel.forms, id: \.formId) { form in
                NavigationLink(destination: FormEntriesView(formId: form.formId)) {
                    Text(form.title)
                }
            }
            .navigationTitle("Form List")
            .onAppear {
                viewModel.loadAndInsertFormsIfNeeded()
            }
        }
    }
}

