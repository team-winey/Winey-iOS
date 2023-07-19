//
//  FeedService.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

import Moya

final class FeedService {
    
    let feedProvider = CustomMoyaProvider<API>()
    
    init() { }
    
    private(set) var feedData: BaseResponse<GetFeedResponse>?
    private(set) var postData: BaseResponse<PostFeedResponse>?
    
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
    
    // 3. 피드 업로드하기
    
    func postFeed(feed: UploadModel, completion: @escaping (BaseResponse<PostFeedResponse>?) -> Void) {
        feedProvider.request(.postFeed(feed: feed)) { [self] result in
            switch result {
            case .success(let response):
                do {
                    self.postData = try response.map(BaseResponse<PostFeedResponse>.self)
                    completion(postData)
                } catch let error {
                    if ((NetworkConstant.postfeedHeader["userId"]?.isEmpty) != nil) {
                        print("존재하지 않는 유저입니다", 404, error.localizedDescription)
                    }
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
