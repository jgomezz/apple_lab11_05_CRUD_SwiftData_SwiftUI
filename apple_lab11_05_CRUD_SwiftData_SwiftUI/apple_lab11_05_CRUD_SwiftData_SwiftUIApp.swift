//
//  apple_lab11_05_CRUD_SwiftData_SwiftUIApp.swift
//  apple_lab11_05_CRUD_SwiftData_SwiftUI
//
//  Created by developer on 5/23/25.
//

import SwiftUI
import SwiftData

@main
struct apple_lab11_05_CRUD_SwiftData_SwiftUIApp: App {
    
    var sharedModelContainer: ModelContainer = {

        let schema = Schema([
            Teacher.self,
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
