//
//  UserManager.swift
//  Winey
//
//  Created by Woody Lee on 2023/07/20.
//

import Foundation

struct UserManager: UserDefaultManager {
    typealias T = Int
    private let key: String
    
    init(key: UserDefaults.Name) {
        self.key = key.rawValue
    }
    
    var value: T? {
        return UserDefaults.standard.value(forKey: key) as? T
    }
    
    var isEmpty: Bool {
        return UserDefaults.standard.value(forKey: key) == nil
    }
    
    func save<T>(_ value: T) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func removeAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

// TODO: 데모데이를 위한 객체 ㅠㅠ

struct UserSingleton {
    private static let userManager = UserManager(key: .user)
    private init() {}
    
    static func getId() -> Int {
        userManager.value ?? -1
    }
    
    static func saveId(_ id: Int) {
        userManager.save(id)
    }
}