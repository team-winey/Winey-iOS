//
//  FeedService.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

import Moya

final class FeedService {
    
    var feedProvider = MoyaProvider<FeedRouter>(plugins: [MoyaLoggerPlugin()])
    
    init() { }
    
    private(set) var totalFeedData: BaseResponse<TotalFeedResponse>?
    
    // 1, 전체 피드 조회하기
    
    func getTotalFeed(page: Int, completion: @escaping (BaseResponse<TotalFeedResponse>?) -> Void) {
        feedProvider.request(.getTotalFeed(page: page)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.totalFeedData = try response.map(BaseResponse<TotalFeedResponse>.self)
                    completion(totalFeedData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
