//
//  GoalService.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

import Moya

final class GoalService {
    
    let goalProvider = CustomMoyaProvider<GoalAPI>(session: Session(interceptor: SessionInterceptor.shared))
    
    init() { }
    
    private(set) var goalData: BaseResponse<PostGoalResponse>?
    
    // 1, 전체 피드 조회
    
    func postGoal(request: PostGoalRequest, completion: @escaping (BaseResponse<PostGoalResponse>?) -> Void) {
        goalProvider.request(.postGoal(request: request)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.goalData = try response.map(BaseResponse<PostGoalResponse>.self)
                    completion(goalData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
