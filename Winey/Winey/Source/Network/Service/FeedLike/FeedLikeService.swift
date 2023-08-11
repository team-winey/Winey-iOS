//
//  FeedLikeService.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

import Moya

final class FeedLikeService {
    
    let feedLikeProvider = CustomMoyaProvider<FeedLikeAPI>(session: Session(interceptor: SessionInterceptor.shared))
    
    init() { }
    
    private(set) var feedLikeData: BaseResponse<FeedLikeResponse>?
    
    // 1, 피드 좋아요 / 취소 하기
    
    func postFeedLike(feedId: Int, feedLike: Bool, completion: @escaping (BaseResponse<FeedLikeResponse>?) -> Void) {
        feedLikeProvider.request(.postLike(feedId: feedId, feedLike: feedLike)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.feedLikeData = try response.map(BaseResponse<FeedLikeResponse>.self)
                    completion(feedLikeData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
