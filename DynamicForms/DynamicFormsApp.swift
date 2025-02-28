//
//  DynamicFormsApp.swift
//  DynamicForms
//
//  Created by Caio Cesar Franco Fausto de Freitas on 26/02/25.
//

import SwiftUI

@main
struct DynamicFormsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            FormListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
