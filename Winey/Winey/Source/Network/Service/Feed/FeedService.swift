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
                print(err)
            }
        }
    }
    
    // 3. 피드 업로드
    
    func feedPost(_ imageData: Data, _ feed: UploadModel,
                  _ completionHandler: @escaping ((Bool) -> Void)) {
        
        let url = "\(URLConstant.baseURL)/feed"
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data", "userId": "1"]
        
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
            
            switch statusCode {
            case 200..<300:
                print("게시물 등록 성공")
                completionHandler(true)
            default:
                print("게시물 등록 실패")
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
                case .failure(let err):
                    print(err.localizedDescription)
                    completion(false)
                }
            }
        }
}
