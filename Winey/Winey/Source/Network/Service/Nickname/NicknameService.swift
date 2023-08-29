//
//  NicknameService.swift
//  Winey
//
//  Created by 김응관 on 2023/08/19.
//

import Foundation

import Moya

final class NicknameService {
    let nickNameprovider = CustomMoyaProvider<NicknameAPI>(session: Session(interceptor: SessionInterceptor.shared))
    
    private var duplicateResponse: DuplicateCheckResponse?
    
    // 1. 닉네임 설정
    
    func setNickname(nickname: String, completion: @escaping ((Bool) -> Void)) {
        nickNameprovider.request(.changeNickname(nickname: nickname)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200..<300:
                    UserSingleton.saveNickname(nickname)
                    completion(true)
                default:
                    completion(false)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. 닉네임 중복확인
    
    func duplicateCheck(nickname: String, completion: @escaping ((DuplicateCheckResponse?) -> Void)) {
        nickNameprovider.request(.checkNicknameDuplicate(nickname: nickname)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200..<300:
                    do {
                        self.duplicateResponse = try response.map(DuplicateCheckResponse.self)
                        completion(self.duplicateResponse)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                default:
                    print("error")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
