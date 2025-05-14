//
//  KeychainHelper.swift
//  GenericRestaurant
//
//  Created by Noel Obando Espinoza on 5/13/25.
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}

    func save(_ data: Data, service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary) // Elimina valor anterior si existe
        SecItemAdd(query as CFDictionary, nil)
    }

    func readData(service: String, account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess {
            return result as? Data
        } else {
            return nil
        }
    }

    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }

    // Helpers para usar con String
    func saveString(_ value: String, service: String, account: String) {
        if let data = value.data(using: .utf8) {
            save(data, service: service, account: account)
        }
    }
    func readString(service: String, account: String) -> String? {
        guard let data = readData(service: service, account: account) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
