//
//  URLConstant.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

struct URLConstant {
    
    static let baseURL = (Bundle.main.infoDictionary?["BASE_URL"] as! String).replacingOccurrences(of: " ", with: "")
    
    // MARK: - Route
    
    static let feed = "/feed"
    static let myfeed = "/feed/myFeed"
    static let goal = "/goal"
    static let feedLike = "/feedLike"
    static let user = "/user"
    static let recommend = "/recommend"
    static let signIn = "/auth"
    static let signOut = "/auth/sign-out"
    static let withdraw = "/auth/withdraw"
}
