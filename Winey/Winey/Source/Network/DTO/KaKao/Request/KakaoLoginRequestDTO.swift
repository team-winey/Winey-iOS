//
//  KakaoLoginRequestDTO.swift
//  Winey
//
//  Created by 고영민 on 2023/08/08.
//

import Foundation

// MARK: - KakaoLoginRequestDTO
struct KakaoLoginRequestDTO: Codable {
    let accessToken, social: String
}
