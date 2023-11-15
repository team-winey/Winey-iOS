//
//  BaseResponse.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    var code: Int
    var success: Bool
    var message: String?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case code
        case success
        case message
        case data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = (try? values.decode(Int.self, forKey: .code)) ?? 0
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
    }
}

struct EmptyResponseData: Decodable {}

typealias EmptyResponse = BaseResponse<EmptyResponseData>
