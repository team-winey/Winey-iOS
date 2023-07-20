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
    
    // 1, 추천 절약법 조회
    
    func getTotalRecommend(page: Int, completion: @escaping (TotalRecommendResponse) -> Void) {
        recommendProvider.request(.getTotalRecommend(page: page)) { result in
            switch result {
            case .success(let response):
                do {
                    let dto = try response.map(BaseResponse<TotalRecommendResponse>.self)
                    guard let recommendsDTO = dto.data else { return }
                    completion(recommendsDTO)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
