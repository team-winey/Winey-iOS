//
//  UserDefaultsManager.swift
//  Winey
//
//  Created by Woody Lee on 2023/07/20.
//

import Foundation

protocol UserDefaultManager {
    associatedtype T
    
    var value: T? { get }
    var isEmpty: Bool { get }
    func save<T>(_ value: T)
    func removeAll()
}
