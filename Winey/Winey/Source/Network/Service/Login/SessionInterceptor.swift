//
//  SessionInterceptor.swift
//  Winey
//
//  Created by 김응관 on 2023/08/09.
//

import Combine
import Foundation

import Alamofire
import DesignSystem
import Moya
import UIKit

final class SessionInterceptor: RequestInterceptor {
    
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
    
//    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        print("retry 진입")
//        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode >= 400 else {
//            dump(error)
//            completion(.doNotRetryWithError(error))
//            return
//        }
//
//        guard let refreshToken = KeychainManager.shared.read("refreshToken") else { return }
//
//        LoginService.shared.reissueApple(token: refreshToken) { result in
//            switch result {
//            case .success:
//                print("Retry-토큰 재발급 성공")
//                completion(.retry)
//            case .failure(let error):
//                completion(.doNotRetryWithError(error))
//                return
//            }
//        }
//    }
}




