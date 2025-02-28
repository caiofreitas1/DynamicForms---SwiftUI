//
//  FormRepositoryImpl.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import Foundation
import CoreData

class FormRepositoryImpl: FormRepository {
    private let localDataSource: FormLocalDataSource

    init(localDataSource: FormLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func insertFormFromDto(formId: String, formDto: FormDto) throws {
        try localDataSource.insertForms([formDto], formIds: [formId])
    }

    func getAllForms() throws -> [Form] {
        let formEntities = try localDataSource.fetchAllForms()
        return formEntities.map { formEntity in
            Form(
                formId: formEntity.formId ?? "",
                title: formEntity.title ?? ""
            )
        }
    }

    func getFormContents(formId: String) throws -> (Form, [Section], [Field])? {
        guard let formEntity = try localDataSource.fetchFormById(formId) else {
            return nil
        }
        
        let form = Form(
            formId: formEntity.formId ?? "",
            title: formEntity.title ?? ""
        )
        
        let sectionEntities = formEntity.sections?.allObjects as? [SectionEntity] ?? []
        let sections = sectionEntities.map { sectionEntity in
            Section(
                sectionId: sectionEntity.sectionId ?? "",
                parentFormId: form.formId,
                title: sectionEntity.title ?? "",
                fromIndex: Int(sectionEntity.fromIndex),
                toIndex: Int(sectionEntity.toIndex),
                index: Int(sectionEntity.index)
            )
        }

        let fieldEntities = formEntity.fields?.allObjects as? [FieldEntity] ?? []
        let fields = fieldEntities.map { fieldEntity in
            let optionEntities = fieldEntity.options?.allObjects as? [OptionEntity] ?? []
            let options = optionEntities.map { optionEntity in
                Option(
                    optionId: optionEntity.optionId ?? "",
                    label: optionEntity.label_ ?? "",
                    value: optionEntity.value ?? ""
                )
            }
            return Field(
                fieldId: fieldEntity.fieldId ?? "",
                parentFormId: form.formId,
                type: fieldEntity.type ?? "",
                label: fieldEntity.label_ ?? "",
                name: fieldEntity.name ?? "",
                required: fieldEntity.required,
                orderIndex: Int(fieldEntity.orderIndex),
                options: options
            )
        }
        
        return (form, sections, fields)
    }

    func getEntriesByFormId(formId: String) throws -> [Entry] {
        let entryEntities = try localDataSource.fetchEntriesByFormId(formId)
        return entryEntities.map { entryEntity in
            let json = entryEntity.fieldValuesJson ?? "{}"
            let map = FormJsonParser.parseFieldValues(json)
            return Entry(
                entryId: entryEntity.entryId ?? "",
                formId: entryEntity.formId ?? "",
                fieldValues: map,
                timestamp: entryEntity.timestamp
            )
        }
    }

    func saveEntry(formId: String, entryId: String, fieldValues: [String: String]) throws {
        let json = FormJsonParser.mapToJson(fieldValues)
        try localDataSource.insertEntry(entryId, formId: formId, fieldValuesJson: json)
    }
}
