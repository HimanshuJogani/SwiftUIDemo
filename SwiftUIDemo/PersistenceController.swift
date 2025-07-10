//
//  PersistenceController.swift
//  SwiftUIDemo
//
//  Created by Himanshu Jogani on 10/07/25.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "SwiftUIDemo")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
    }
}
