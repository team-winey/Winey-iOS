//
//  KeychainManager.swift
//  Winey
//
//  Created by 김응관 on 2023/08/04.
//

import Foundation

struct KeychainManager {
    
    enum KeychainError: Error {
        case noToken
        case unhandledError
        case tokenParsingError
    }
    
    var id: String
    let service = Bundle.main.bundleIdentifier ?? ""
    
    init(id: String) {
        self.id = id
    }
    
    private static func keychainQuery(id: String) -> [String: AnyObject] {
        
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        // query[kSecAttrService as String] = KeychainManager.service as AnyObject
        query[kSecAttrAccount as String] = id as AnyObject
        
        return query
    }
    
    func saveToken(_ token: String) throws {
        let encodedToken = token.data(using: String.Encoding.utf8)!
        
        let query: NSDictionary = [kSecClass: kSecClassGenericPassword,
                             kSecAttrAccount: id,
                               kSecValueData: encodedToken,
                             kSecAttrService: service]
        
        let status = SecItemAdd(query, nil)
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError }
    }
    
    func updateToken(_ token: String) throws {
        let encodedToken = token.data(using: String.Encoding.utf8)!

        let query: NSDictionary = [kSecClass: kSecClassGenericPassword,
                             kSecAttrAccount: id,
                             kSecAttrService: service]
        
        let targetQuery: NSDictionary = [kSecValueData: encodedToken]
        
        let status = SecItemUpdate(query, targetQuery)
        
        guard status == errSecSuccess else { throw KeychainError.unhandledError }
    }
    
    func getToken() throws -> String? {
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
    
    static func deleteToken() throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status != errSecItemNotFound else { throw KeychainError.noToken }
        guard status == errSecSuccess else { throw KeychainError.unhandledError }
    }
}
