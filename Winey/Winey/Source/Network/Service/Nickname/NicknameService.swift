//
//  NicknameService.swift
//  Winey
//
//  Created by 김응관 on 2023/08/19.
//

import Foundation

import Moya

final class NicknameService {
    let nickNameprovider = CustomMoyaProvider<NicknameAPI>()
    
    // 1. 닉네임 설정
    
    func setNickname(nickname: String, completion: @escaping ((Bool) -> Void)) {
        nickNameprovider.request(.changeNickname(nickname: nickname)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200..<300:
                    completion(true)
                default:
                    completion(false)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
