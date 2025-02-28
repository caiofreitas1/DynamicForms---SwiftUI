//
//  FormLocalDataSource.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 27/02/25.
//

import CoreData
import Foundation

protocol FormLocalDataSource {
    func insertForms(_ forms: [FormDto], formIds: [String]) throws
    
    
    func fetchAllForms() throws -> [FormEntity]
    func fetchFormById(_ formId: String) throws -> FormEntity?
    
    func fetchSectionsByFormId(_ formId: String) throws -> [SectionEntity]
    func fetchFieldsByFormId(_ formId: String) throws -> [FieldEntity]
    func fetchOptionsByFieldId(_ fieldId: String) throws -> [OptionEntity]
    
    
    func insertEntry(_ entryId: String, formId: String, fieldValuesJson: String) throws
    func fetchEntriesByFormId(_ formId: String) throws -> [EntryEntity]
    
    
    func deleteAllForms() throws
    func deleteEntriesByFormId(_ formId: String) throws
}

class FormLocalDataSourceImpl: FormLocalDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func insertForms(_ formDtos: [FormDto], formIds: [String]) throws {
        for (index, dto) in formDtos.enumerated() {
            let formId = formIds[index]
            
            let formEntity = FormEntity(context: context)
            formEntity.formId = formId
            formEntity.title = dto.title

            for sectionDto in dto.sections {
                let sectionEntity = SectionEntity(context: context)
                sectionEntity.sectionId = sectionDto.uuid
                sectionEntity.title = sectionDto.title
                sectionEntity.fromIndex = Int32(sectionDto.from)
                sectionEntity.toIndex = Int32(sectionDto.to)
                sectionEntity.index = Int32(sectionDto.index)
                sectionEntity.parentForm = formEntity
            }

            for (order, fieldDto) in dto.fields.enumerated() {
                let fieldEntity = FieldEntity(context: context)
                fieldEntity.fieldId = fieldDto.uuid
                fieldEntity.type = fieldDto.type
                fieldEntity.label_ = fieldDto.label
                fieldEntity.name = fieldDto.name
                fieldEntity.required = fieldDto.required ?? false
                fieldEntity.orderIndex = Int32(order)
                fieldEntity.parentForm = formEntity

                if let options = fieldDto.options {
                    for opt in options {
                        let optionEntity = OptionEntity(context: context)
                        optionEntity.optionId = "\(fieldDto.uuid)-\(opt.value)"
                        optionEntity.label_ = opt.label
                        optionEntity.value = opt.value
                        optionEntity.parentField = fieldEntity
                    }
                }
            }
        }
        try context.save()
    }

    func fetchAllForms() throws -> [FormEntity] {
        let request = NSFetchRequest<FormEntity>(entityName: "FormEntity")
        return try context.fetch(request)
    }

    func fetchFormById(_ formId: String) throws -> FormEntity? {
        let request = NSFetchRequest<FormEntity>(entityName: "FormEntity")
        request.predicate = NSPredicate(format: "formId == %@", formId)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    func fetchSectionsByFormId(_ formId: String) throws -> [SectionEntity] {
        let request = NSFetchRequest<SectionEntity>(entityName: "SectionEntity")
        request.predicate = NSPredicate(format: "parentForm.formId == %@", formId)
        return try context.fetch(request)
    }

    func fetchFieldsByFormId(_ formId: String) throws -> [FieldEntity] {
        let request = NSFetchRequest<FieldEntity>(entityName: "FieldEntity")
        request.predicate = NSPredicate(format: "parentForm.formId == %@", formId)
        return try context.fetch(request)
    }

    func fetchOptionsByFieldId(_ fieldId: String) throws -> [OptionEntity] {
        let request = NSFetchRequest<OptionEntity>(entityName: "OptionEntity")
        request.predicate = NSPredicate(format: "parentField.fieldId == %@", fieldId)
        return try context.fetch(request)
    }

    func insertEntry(_ entryId: String, formId: String, fieldValuesJson: String) throws {
        let entryEntity = EntryEntity(context: context)
        entryEntity.entryId = entryId
        entryEntity.formId = formId
        entryEntity.fieldValuesJson = fieldValuesJson
        entryEntity.timestamp = Date().timeIntervalSince1970
        try context.save()
    }

    func fetchEntriesByFormId(_ formId: String) throws -> [EntryEntity] {
        let request = NSFetchRequest<EntryEntity>(entityName: "EntryEntity")
        request.predicate = NSPredicate(format: "formId == %@", formId)
        return try context.fetch(request)
    }

    func deleteAllForms() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FormEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try context.save()
    }

    func deleteEntriesByFormId(_ formId: String) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "EntryEntity")
        fetchRequest.predicate = NSPredicate(format: "formId == %@", formId)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try context.save()
    }
}
