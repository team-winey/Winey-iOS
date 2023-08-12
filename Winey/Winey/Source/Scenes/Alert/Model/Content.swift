//
//  Content.swift
//  Winey
//
//  Created by 고영민 on 2023/08/05.
//

import UIKit

@frozen

enum Content {
    case levelup
    case leveldown
    case comment
    case like
    case encourage
    
    var title: String {
        switch self {
        case.levelup: // TODO: 계급에 따라 텍스트변동
            return "(getNetw)가 되신걸 축하해요"
        case .leveldown: // TODO: 계급에 따라 텍스트변동
            return "(getNetw)가 되어서 내려갔어요"
        case .comment:
            return "(getNetw)님이 댓글을 남겼어요"
        case .like:
            return "(getNetw)님이 회원님의 게시글을 좋아해요"
        case .encourage:
            return "이번에는 아쉽지만 힘내서 다음 목표를 정해볼까요?"
        }
    }
    var image: UIImage {
        switch self {
        case.levelup:
            return .Img.emperor! // TODO: 계급에 따라 이미지변동
        case .leveldown:
            return .Img.noble! // TODO: 계급에 따라 이미지변동
        case .comment:
            return .Icon.comment!
        case .like:
            return .Icon.like!
        case .encourage:
            return .Icon.winey!
        }
    }
}
