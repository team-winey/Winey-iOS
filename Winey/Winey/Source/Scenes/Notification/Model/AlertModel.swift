//
//  AlertModel.swift
//  Winey
//
//  Created by 고영민 on 2023/08/05.
//

import UIKit

struct Alert {
    let centralImage: UIImage
    let category: String
    let content: String
    let elapsedTime: String
}

extension Alert {
    
}

struct Carrot {
    let image: UIImage
    let product: String
    let place: String
    let time: String
    let tradeStatus: Trade
    let price: Int
}

@frozen
enum Trade {
    case reservation
    case completed
    case shared
    case clear
    
    var title: String {
        switch self {
        case .reservation:
            return "예약중"
        case .completed:
            return "거래완료"
        case .shared:
            return "나눔완료"
        case .clear:
            return ""
        }
    }
    
