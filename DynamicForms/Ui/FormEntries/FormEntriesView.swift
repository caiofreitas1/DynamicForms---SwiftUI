//
//  FormEntriesView.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import SwiftUI

import SwiftUI

struct FormEntriesView: View {
    @StateObject private var viewModel: FormEntriesViewModel
    let formId: String

    init(formId: String) {
        self.formId = formId

        let context = PersistenceController.shared.container.viewContext
        let dataSource = FormLocalDataSourceImpl(context: context)
        let repo = FormRepositoryImpl(localDataSource: dataSource)
        _viewModel = StateObject(wrappedValue: FormEntriesViewModel(repository: repo, formId: formId))
    }

    var body: some View {
        VStack {
            Text("Form entries: \(formId)")
                .font(.headline)
                .padding()

            if viewModel.entries.isEmpty {
                Text("No entries found.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(groupedEntries.sorted(by: { $0.key > $1.key }), id: \.key) { date, entries in
                        SwiftUI.Section(header: Text(date)) {
                            ForEach(entries, id: \.entryId) { entry in
                                EntryRow(entry: entry)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }

            NavigationLink("Add New Entry") {
                FormEntryView(formId: formId)
            }
            .padding()
        }
        .onAppear {
            viewModel.loadEntries()
        }
    }

    private var groupedEntries: [String: [Entry]] {
        Dictionary(grouping: viewModel.entries) { entry in
            let date = Date(timeIntervalSince1970: entry.timestamp)
            return dateFormatter.string(from: date)
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

struct EntryRow: View {
    let entry: Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Entry ID: \(entry.entryId)")
                .font(.caption)
                .foregroundColor(.gray)

            ForEach(entry.fieldValues.keys.sorted(), id: \.self) { key in
                let val = entry.fieldValues[key] ?? ""
                HStack {
                    Text(key)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(val)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
