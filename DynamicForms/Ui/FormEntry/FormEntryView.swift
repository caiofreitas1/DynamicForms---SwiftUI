//
//  FormEntryView.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import SwiftUI

struct FormEntryView: View {
    @StateObject private var viewModel: FormEntryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(formId: String) {
        let context = PersistenceController.shared.container.viewContext
        let dataSource = FormLocalDataSourceImpl(context: context)
        let repo = FormRepositoryImpl(localDataSource: dataSource)
        _viewModel = StateObject(wrappedValue: FormEntryViewModel(repository: repo, formId: formId))
    }
    
    var body: some View {
        VStack {
            if let form = viewModel.form {
                Text("Form: \(form.title)")
                    .font(.headline)
                    .padding()
                
                List {
                    ForEach(viewModel.sections, id: \.sectionId) { section in
                        SwiftUI.Section {
                            ForEach(viewModel.fields(in: section), id: \.fieldId) { field in
                                FieldView(
                                    field: field,
                                    value: Binding(
                                        get: { viewModel.fieldValues[field.fieldId] ?? "" },
                                        set: { newValue in
                                            viewModel.updateFieldValue(fieldId: field.fieldId, newValue: newValue)
                                        }
                                    )
                                )
                            }
                        } header: {
                            AttributedText(html: section.title)
                                .padding(.vertical, 8)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                
                Button("Save") {
                    viewModel.saveEntry {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding()
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            viewModel.loadForm()
        }
    }
}
