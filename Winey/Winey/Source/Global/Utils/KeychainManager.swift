//
//  KeychainManager.swift
//  Winey
//
//  Created by 김응관 on 2023/08/04.
//

import Foundation

class KeychainManager {
    
    enum KeychainError: Error {
        case noToken
        case unhandledError
        case tokenParsingError
    }
    
    // Singleton
    static let shared = KeychainManager()
    
    let service = Bundle.main.bundleIdentifier ?? ""

    func saveToken(_ token: String, _ id: String) throws {
        let encodedToken = token.data(using: String.Encoding.utf8)!
        
        let query: NSDictionary = [kSecClass: kSecClassGenericPassword,
                             kSecAttrAccount: id,
                               kSecValueData: encodedToken,
                             kSecAttrService: service]
        
        let status = SecItemAdd(query, nil)
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError }
    }
    
    func updateToken(_ token: String, _ id: String) throws {
        let encodedToken = token.data(using: String.Encoding.utf8)!

        let query: NSDictionary = [kSecClass: kSecClassGenericPassword,
                             kSecAttrAccount: id,
                             kSecAttrService: service]
        
        let targetQuery: NSDictionary = [kSecValueData: encodedToken]
        
        let status = SecItemUpdate(query, targetQuery)
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError }
    }
    
    func getToken(_ id: String) throws -> String? {
        let query: NSDictionary = [kSecClass: kSecClassGenericPassword,
                                 kSecAttrAccount: id,
                            kSecReturnAttributes: true,
                                  kSecReturnData: true]
        
        var searchedResult: CFTypeRef?
        let searchStatus = SecItemCopyMatching(query, &searchedResult)
        
        if searchStatus == errSecSuccess {
            guard let checkedItem = searchedResult,
            let token = checkedItem[kSecValueData] as? Data,
            let strToken = String(data: token, encoding: String.Encoding.utf8) else {
                throw KeychainError.tokenParsingError
            }
            return strToken
        } else {
            throw KeychainError.noToken
        }
    }
    
    func deleteToken(_ id: String) throws {
        let query: NSDictionary = [kSecClass: kSecClassGenericPassword,
                                 kSecAttrAccount: id,
                             kSecAttrService: service]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status != errSecItemNotFound else { throw KeychainError.noToken }
        guard status == errSecSuccess else { throw KeychainError.unhandledError }
    }
    
    func read(_ id: String) -> String? {
        var token: String?
        
        do {
            token = try getToken(id)
        } catch {
            print("err")
        }
        return token
    }
    
    func create(_ token: String, _ id: String) {
        do {
            try saveToken(token, id)
            print("save token")
        } catch {
            print("token saving error")
        }
    }
    
    func update(_ token: String, _ id: String) {
        do {
            try updateToken(token, id)
            print("update token")
        } catch {
            print("token updating error")
        }
    }
    
    func delete(_ id: String) {
        do {
            try deleteToken(id)
        } catch {
            print("token delete error")
        }
    }
}
