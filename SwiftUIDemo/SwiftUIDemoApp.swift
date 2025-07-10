//
//  SwiftUIDemoApp.swift
//  SwiftUIDemo
//
//  Created by Himanshu Jogani on 10/07/25.
//

import SwiftUI

@main
struct SwiftUIDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
