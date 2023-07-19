//
//  ProductPolicy.swift
//  Winey
//
//  Created by Woody Lee on 2023/07/20.
//

import Foundation

enum ProductPolicy: String {
    case error
    case 계란빵
    case 추파춥스
    case 삼각김밥
    case 음료수
    case 샌드위치
    case 스타벅스_커피 = "스타벅스 커피"
    case 샐러드
    case 국밥
    case 야간_택시비 = "야간 택시비"
    case 삼겹살
    case 스시
    case 피자_한_판 = "피자 한 판"
    case 치킨
    case KTX_기차표 = "KTX 기차표"
    case 소고기
    
    static func productBy(_ cost: UploadModel.Cost) -> ProductPolicy {
        switch cost {
        case 0..<500: return .계란빵
        case 500..<1000: return .추파춥스
        case 1000..<1500: return .삼각김밥
        case 1500..<2500: return .음료수
        case 2500..<4500: return .샌드위치
        case 4500..<6000: return .스타벅스_커피
        case 6000..<8000: return .샐러드
        case 8000..<10000: return .국밥
        case 10000..<12000: return .야간_택시비
        case 12000..<14000: return .삼겹살
        case 14000..<16000: return .스시
        case 16000..<18000: return .피자_한_판
        case 18000..<20000: return .치킨
        case 20000..<40000: return .KTX_기차표
        default: return .소고기
        }
    }
}
