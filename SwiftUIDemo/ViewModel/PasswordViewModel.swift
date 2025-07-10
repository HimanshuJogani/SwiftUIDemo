//
//  PasswordViewModel.swift
//  SwiftUIPractice
//
//  Created by Himanshu Jogani on 09/07/25.
//

import Foundation
import CoreData
import LocalAuthentication
import CryptoKit

class PasswordViewModel: ObservableObject {
    @Published var entries: [PasswordEntryEntity] = []
    @Published var isAuthenticated: Bool = false
    let context = PersistenceController.shared.container.viewContext

    init() {
        fetchEntries()
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Access your passwords") { success, error in
                DispatchQueue.main.async {
                    self.isAuthenticated = success
                }
            }
        } else {
            isAuthenticated = true
        }
    }

    func fetchEntries() {
        let request: NSFetchRequest<PasswordEntryEntity> = PasswordEntryEntity.fetchRequest()
        do {
            entries = try context.fetch(request)
        } catch {
            print("Failed to fetch: \(error)")
        }
    }

    func add(accountType: String, username: String, password: String) {
        let entry = PasswordEntryEntity(context: context)
        entry.id = UUID()
        entry.accountType = accountType
        entry.username = username
        
        KeychainHelper.shared.savePassword(password, for: entry.id!)
        saveContext()
        fetchEntries()
    }

    func update(_ entry: PasswordEntryEntity, username: String, password: String) {
        entry.username = username
        if let id = entry.id {
            KeychainHelper.shared.savePassword(password, for: id)
        }
        saveContext()
        fetchEntries()
    }

    func delete(_ entry: PasswordEntryEntity) {
        if let id = entry.id {
            KeychainHelper.shared.deletePassword(for: id)
        }
        context.delete(entry)
        saveContext()
        fetchEntries()
    }

    private func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
