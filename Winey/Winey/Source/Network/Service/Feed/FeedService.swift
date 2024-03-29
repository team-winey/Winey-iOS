//
//  FeedService.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation
import UIKit

import Alamofire
import Moya

final class FeedService {
    
    let feedProvider = CustomMoyaProvider<FeedAPI>()
    
    init() { }
    
    private(set) var feedData: BaseResponse<GetFeedResponse>?
    
    // 1, 전체 피드 조회
    
    func getTotalFeed(page: Int, completion: @escaping (BaseResponse<GetFeedResponse>?) -> Void) {
        feedProvider.request(.getTotalFeed(page: page)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.feedData = try response.map(BaseResponse<GetFeedResponse>.self)
                    completion(feedData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                LoginService.shared.reissueApple(token: KeychainManager.shared.read("refreshToken") ?? "") { _ in }
                print(err)
            }
        }
    }
    
    // 2. 마이 피드 조회
    
    func getMyFeed(page: Int, completion: @escaping (BaseResponse<GetFeedResponse>?) -> Void) {
        feedProvider.request(.getMyFeed(page: page)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.feedData = try response.map(BaseResponse<GetFeedResponse>.self)
                    completion(feedData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                LoginService.shared.reissueApple(token: KeychainManager.shared.read("refreshToken") ?? "") { _ in }
                print(err)
            }
        }
    }
    
    // 3. 피드 업로드
    
    func feedPost(_ imageData: Data, _ feed: UploadModel,
                  _ completionHandler: @escaping ((Bool) -> Void)) {
        
        //        API.session.upload(multipartFormData: { multipartFormData in
        //            multipartFormData.append(Data(feed.feedTitle.utf8), withName: "feedTitle")
        //            multipartFormData.append(Data(String(feed.feedMoney).utf8), withName: "feedMoney")
        //            multipartFormData.append(
        //                imageData,
        //                withName: "feedImage",
        //                fileName: "feedImage.jpeg",
        //                mimeType: "feedImage/jpeg"
        //            )
        //        }, to: url, method: .post)
        //        .validate()
        //        .responseData { response in
        //            guard let statusCode = response.response?.statusCode else { return }
        //            let result = response.result
        //
        //            switch result {
        //            case .success:
        //                switch statusCode {
        //                case 200..<300:
        //                    completionHandler(true)
        //                default:
        //                    completionHandler(false)
        //                }
        //            case .failure(let err):
        //                print("here")
        //                LoginService.shared.reissueApple(token: KeychainManager.shared.read("refreshToken") ?? "") { _ in }
        //                print(err)
        //                completionHandler(false)
        //            }
        //        }
        
        let url = "\(URLConstant.baseURL)/feed"
        let token = KeychainManager.shared.read("accessToken")!
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data", "accessToken": token]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(feed.feedTitle.utf8), withName: "feedTitle")
            multipartFormData.append(Data(String(feed.feedMoney).utf8), withName: "feedMoney")
            multipartFormData.append(
                imageData,
                withName: "feedImage",
                fileName: "feedImage.jpeg",
                mimeType: "feedImage/jpeg"
            )
        }, to: url, method: .post, headers: header)
        .responseData { response in
            guard let statusCode = response.response?.statusCode else { return }
            let result = response.result
            
            switch result {
            case .success:
                switch statusCode {
                case 200..<300:
                    completionHandler(true)
                default:
                    completionHandler(false)
                }
            case .failure(let err):
                print(err)
                completionHandler(false)
            }
        }
    }
    
    // 4. 마이 피드 삭제하기
    func deleteMyFeed(_ idx: Int, _ completion: @escaping ((Bool) -> Void)) {
        feedProvider.request(.deleteMyFeed(idx: idx)) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    typealias FeedDetailRes = BaseResponse<FeedDetailResponse>
    func fetchDetailFeed(feedId: Int) async throws -> FeedDetailResponse {
        return try await withCheckedThrowingContinuation { continuation in
            feedProvider.request(.detail(id: feedId)) { result in
                do {
                    guard let response = try result.get().map(FeedDetailRes.self).data
                    else { throw FeedNetworkError.undefined }
                    continuation.resume(returning: response)
                } catch {
                    LoginService.shared.reissueApple(token: KeychainManager.shared.read("refreshToken") ?? "") { _ in }
                    continuation.resume(throwing: FeedNetworkError.undefined)
                }
            }
        }
    }
    
    private enum FeedNetworkError: Error {
        case undefined
    }
}

//class API {
//    static let session: Session = {
//        let interceptorConfig = URLSessionConfiguration.af.default
//        // interceptorConfig.timeoutIntervalForRequest = 10
//        // interceptorConfig.waitsForConnectivity = true
//        let interceptor = SessionInterceptor()
//
//        return Session(configuration: interceptorConfig, interceptor: interceptor)
//    }()
//}
