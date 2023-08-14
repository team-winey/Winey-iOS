//
//  File.swift
//  
//
//  Created by 김응관 on 2023/08/15.
//

import UIKit

public struct WIToastType {
    public let text: UILabel
    public let icon: UIImage
    
    public init(text: UILabel, icon: UIImage) {
        self.text = text
        self.icon = icon
    }
}

public extension WIToastType {
    static let uploadSuccess: WIToastType = WIToastType(
        text: Toast.uploadSuccess.text,
        icon: Toast.uploadSuccess.icon
    )
    
    static let uploadFail: WIToastType = WIToastType(
        text: Toast.uploadFail.text,
        icon: Toast.uploadFail.icon
    )
}

public extension WIToastType {
    enum Toast {
        case uploadSuccess
        case uploadFail
    }
    
    var text: String {
        switch self {
        case .uploadSuccess:
            return "업로드가 완료되었습니다 :)"
        case .uploadFail:
            return "죄송합니다. 업로드에 실패했습니다 :("
        }
    }
    
    var icon: UIImage {
        switch self {
        case .uploadSuccess:
            return .success
        case .uploadFail:
            return .fail
        }
    }
}
