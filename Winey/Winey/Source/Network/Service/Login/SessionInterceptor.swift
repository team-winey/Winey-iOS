//
//  SessionInterceptor.swift
//  Winey
//
//  Created by 김응관 on 2023/08/09.
//

import Foundation

import Moya

final class SessionInterceptor: RequestInterceptor {
    
    static let shared = SessionInterceptor()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(URLConstant.baseURL) == true,
            let accessToken = KeychainManager.shared.read("accessToken"),
            let refreshToken = KeychainManager.shared.read("refreshToken")
        else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "accessToken")
        urlRequest.setValue(refreshToken, forHTTPHeaderField: "refreshToken")
        print("adaptor 적용 \(urlRequest.headers)")
        completion(.success(urlRequest))
    }
}
