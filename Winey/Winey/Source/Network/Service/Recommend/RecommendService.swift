//
//  RecommendService.swift
//  Winey
//
//  Created by 김인영 on 2023/07/20.
//

import Foundation

import Moya

final class RecommendService {
    
    let recommendProvider = CustomMoyaProvider<RecommendAPI>()
    
    init() {}
    
    private(set) var recommendData: BaseResponse<TotalRecommendResponse>?
    
    // 1, 추천 절약법 조회
    
    func getTotalRecommend(page: Int, completion: @escaping (BaseResponse<TotalRecommendResponse>?) -> Void) {
        recommendProvider.request(.getTotalRecommend(page: page)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.recommendData = try response.map(BaseResponse<TotalRecommendResponse>.self)
                    completion(self.recommendData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
