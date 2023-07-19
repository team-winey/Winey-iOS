//
//  PostService.swift
//  Winey
//
//  Created by 김응관 on 2023/07/19.
//

import UIKit

import Alamofire
import Moya

final class PostService {
    
    // MARK: - 게시물 작성 API 요청
    func feedPost(_ imageData: Data, _ feed: UploadModel, _ completionHandler: @escaping ((Bool) -> Void)) {
        let url = "\(URLConstant.baseURL)/feed"
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data", "userId": "1"]
        
        AF.upload(multipartFormData: { multipartFormData in
            // 기본타입 처리
            multipartFormData.append(Data(feed.feedTitle.utf8), withName: "feedTitle")
            multipartFormData.append(Data(String(feed.feedMoney).utf8), withName: "feedMoney")
            
            // UIImage 처리
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
}
