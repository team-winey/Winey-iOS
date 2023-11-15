//
//  File.swift
//  
//
//  Created by 김응관 on 2023/08/15.
//

import UIKit

public struct WIToastType {
    public let text: String
    public let icon: UIImage
    
    public init(text: String, icon: UIImage) {
        self.text = text
        self.icon = icon
    }
}

public extension WIToastType {
    static let uploadSuccess: WIToastType = WIToastType(
        text: Toast.uploadSuccess.toastText,
        icon: Toast.uploadSuccess.toastIcon
    )
    
    static let uploadFail: WIToastType = WIToastType(
        text: Toast.uploadFail.toastText,
        icon: Toast.uploadFail.toastIcon
    )
    static let reportSuccess: WIToastType = WIToastType(
        text: Toast.reportSuccess.toastText,
        icon: Toast.reportSuccess.toastIcon
    )
    
    static let reportFail: WIToastType = WIToastType(
        text: Toast.reportFail.toastText,
        icon: Toast.reportFail.toastIcon
    )
    
    static let commentDeleteSuccess: WIToastType = WIToastType(
        text: Toast.commentDeleteSuccess.toastText,
        icon: Toast.commentDeleteSuccess.toastIcon
    )
    
    static let commentDeleteFail: WIToastType = WIToastType(
        text: Toast.commentDeleteFail.toastText,
        icon: Toast.commentDeleteFail.toastIcon
    )
    
    static let feedDeleteSuccess: WIToastType = WIToastType(
        text: Toast.feedDeleteSuccess.toastText,
        icon: Toast.feedDeleteSuccess.toastIcon
    )
    
    static let feedDeleteFail: WIToastType = WIToastType(
        text: Toast.feedDeleteFail.toastText,
        icon: Toast.feedDeleteFail.toastIcon
    )
}

public extension WIToastType {
    enum Toast {
        case uploadSuccess
        case uploadFail
        case reportSuccess
        case reportFail
        case commentDeleteSuccess
        case commentDeleteFail
        case feedDeleteSuccess
        case feedDeleteFail
        
        var toastText: String {
            switch self {
            case .uploadSuccess:
                return "업로드가 완료되었습니다 :)"
            case .uploadFail:
                return "죄송합니다. 업로드에 실패했습니다 :("
            case .reportSuccess:
                return "정상적으로 신고되었습니다 :)"
            case .reportFail:
                return "죄송합니다. 신고 접수에 실패하였습니다."
            case .commentDeleteSuccess:
                return "댓글이 삭제되었습니다 :)"
            case .commentDeleteFail, .feedDeleteFail:
                return "죄송합니다. 다시 시도해 주세요."
            case .feedDeleteSuccess:
                return "게시물이 삭제되었습니다"
            }
        }
        
        var toastIcon: UIImage {
            switch self {
            case .uploadSuccess, .reportSuccess, .commentDeleteSuccess, .feedDeleteSuccess:
                return UIImage.Icon.success!
            case .uploadFail, .reportFail, .commentDeleteFail, .feedDeleteFail:
                return UIImage.Icon.fail!
            }
        }
    }
}
