//
//  KeychainHelper.swift
//  SwiftUIDemo
//
//  Created by Himanshu Jogani on 10/07/25.
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()

    private init() {}

    func savePassword(_ password: String, for id: UUID) {
        let key = id.uuidString
        let data = password.data(using: .utf8) ?? Data()
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func getPassword(for id: UUID) -> String? {
        let key = id.uuidString
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        if SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
           let data = result as? Data,
           let password = String(data: data, encoding: .utf8) {
            return password
        }
        return nil
    }

    func deletePassword(for id: UUID) {
        let key = id.uuidString
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
