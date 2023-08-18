//
//  SessionInterceptor.swift
//  Winey
//
//  Created by 김응관 on 2023/08/09.
//

import Foundation
import UIKit

import Alamofire
import DesignSystem
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
        print(response.statusCode)

        // 엑세스 만료 -> 400오류가 돌아오니까 -> 토큰 업데이트 후 -> retry
        // 앱 사용하던 중 accessToken이 만료되었다면? -> 통신오류 -> 토큰 재발급을 통해 accessToken 갱신해줘야함
        // 해당 retry 메서드의 사용빈도 최소화를 위해 splashView가 끝난 시점에서 항상 토큰 갱신을 진행한다!
         let refreshToken = KeychainManager.shared.read("refreshToken")!
         print(refreshToken)

             print("리프레쉬 토큰을 통한 액세스 토큰 재발급")
             LoginService.shared.reissueApple(token: refreshToken) { result in
                 switch result {
                 case true:
                     print("토큰 재발급 성공!")
                     completion(.retry)
                 case false:
                     completion(.doNotRetry)
                 }
             }
         // }
//    else {
//             print("2트 - 스플래쉬 뷰 부터 다시 시작")
//
//             if let vc = UIApplication.shared.windows.filter({$0.isKeyWindow}).first as? UIViewController {
//                 let alert = MIPopupViewController(
//                    content: .init(
//                        title: "세션이 만료되었습니다",
//                        subtitle: "확인 버튼을 눌러서 다시 로그인을 진행해주세요"
//                    )
//                 )
//                 alert.addButton(title: "확인", type: .yellow) {
//                     UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController = LoginViewController()
//                 }
//                 vc.present(alert, animated: true, completion: nil)
//             }
//
//             completion(.doNotRetry)
//         }
    }
}
