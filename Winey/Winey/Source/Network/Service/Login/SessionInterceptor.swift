//
//  SessionInterceptor.swift
//  Winey
//
//  Created by 김응관 on 2023/08/09.
//

import Foundation

import Alamofire
import Moya

final class SessionInterceptor: RequestInterceptor {
    
    static let shared = SessionInterceptor()
    
    // 토큰 가져오기
    func getToken(_ id: String) -> String? {
        do {
            let token = try KeychainManager(id: id).getToken()
            print("get token")
            return token
        } catch {
            print("get token failed")
            return nil
        }
    }
    
    // 토큰 업데이트
    func updateToken(_ token: String, _ id: String) {
        do {
            try KeychainManager(id: id).updateToken(token)
            print("update token")
        } catch {
            print("token updating error")
        }
    }
    
    
    // 토큰 만료시에 400 오류가 떴을때 재통신을 하게끔 도와주는 retry 함수
     func retry(_ request: Request, for session: Session,
               dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry")
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode >= 400
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        print(request.task?.currentRequest?.headers)
        print(request.task?.currentRequest?.allHTTPHeaderFields)
        print(response.statusCode)
        print(response.headers)
        print(response.allHeaderFields)

        // 엑세스 만료 -> 400오류가 돌아오니까 -> 토큰 업데이트 후 -> retry
        // 앱 사용하던 중 accessToken이 만료되었다면? -> 통신오류 -> 토큰 재발급을 통해 accessToken 갱신해줘야함
        // 해당 retry 메서드의 사용빈도 최소화를 위해 splashView가 끝난 시점에서 항상 토큰 갱신을 진행한다!
        let refreshToken = getToken("accessToken")!

        LoginService.shared.reissueApple(token: refreshToken) { result in
            switch result {
            case true:
                print("토큰 재발급 성공!")
                completion(.retry)
            case false:
                completion(.doNotRetry)
            }
        }
    }
}
