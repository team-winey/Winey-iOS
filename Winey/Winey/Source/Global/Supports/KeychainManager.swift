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
    
    init(id: String) {
        self.id = id
    }
    
    private static func keychainQuery(id: String) -> [String: AnyObject] {
        let service = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
        
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        query[kSecAttrAccount as String] = id as AnyObject?
        
        return query
    }
    
    func readToken() throws -> String {
        // 쿼리 생성
        var query = KeychainManager.keychainQuery(id: id)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // 쿼리와 일치하는 키체인 fetch
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // 예외처리
        guard status != errSecItemNotFound else { throw KeychainError.noToken }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        // 찾은 토큰 Parsing
        guard let existingItem = queryResult as? [String: AnyObject],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.tokenParsingError
        }
        
        return password
    }
    
    func saveToken(_ token: Data) throws {
        do {
            // 유저 id key에 해당하는 value가 존재하는지 확인
            try _ = readToken()
            
            // 업데이트 될 토큰을 value 값으로 설정
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = token as AnyObject?
            
            // 쿼리 작성하여 Item 패키징 & 패키징된 Item 키 체인에 추가
            let query = KeychainManager.keychainQuery(id: id)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // 에러 처리
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noToken {
            // 키체인에 원하는 Item이 없는 경우
            var newItem = KeychainManager.keychainQuery(id: id)
            newItem[kSecValueData as String] = token as AnyObject?
            
            // 키체인에 패키징된 Item 새로 추가
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // 에러처리
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }
    
    func getToken() throws -> (String, String)? {
        do {
            // 유저 id key에 해당하는 value가 존재하는지 확인
            try _ = readToken()
            
            // 쿼리 작성
            let query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecReturnAttributes as String: kCFBooleanTrue,
                kSecReturnData as String: kCFBooleanTrue,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            
            // 쿼리에 맞는 아이템을 키 체인에서 찾기
            var result: CFTypeRef?
            
            // 에러 처리
            if SecItemCopyMatching(query as CFDictionary, &result) != errSecSuccess {
                throw KeychainError.unhandledError
            }
            
            // 찾은 토큰 decoding
            guard let data = result as? [String: AnyObject],
                  let tokenData = data[kSecValueData as String] as? Data,
                  let token = String(data: tokenData, encoding: String.Encoding.utf8),
                  let userId = data[kSecAttrAccount as String] as? String
            else {
                throw KeychainError.tokenParsingError
            }
            
            return (token, userId)
        } catch {
            // 키체인에 원하는 Item이 없는 경우
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
