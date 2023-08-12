//
//  ReissueResponse.swift
//  Winey
//
//  Created by 김응관 on 2023/08/09.
//

import Foundation

struct ReissueResponse: Codable {
    let code: Int
    let message: String
    let data: ReissueData
}

struct ReissueData: Codable {
    let accessToken, refreshToken: String
}
