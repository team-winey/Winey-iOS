//
//  FeedService.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation
import UIKit

import Moya

final class FeedService {
    
    let feedProvider = CustomMoyaProvider<API>()
    
    init() { }
    
    private(set) var feedData: BaseResponse<GetFeedResponse>?
    
    // 1, 전체 피드 조회하기
    
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
    
    // 2. 마이 피드 조회하기
    
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
}
