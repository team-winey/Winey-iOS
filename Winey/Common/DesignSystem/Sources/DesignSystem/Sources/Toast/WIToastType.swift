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
}

public extension WIToastType {
    enum Toast {
        case uploadSuccess
        case uploadFail

        var toastText: String {
            switch self {
            case .uploadSuccess:
                return "업로드가 완료되었습니다 :)"
            case .uploadFail:
                return "죄송합니다. 업로드에 실패했습니다 :("
            }
        }

        var toastIcon: UIImage {
            switch self {
            case .uploadSuccess:
                return UIImage.Icon.success!
            case .uploadFail:
                return UIImage.Icon.fail!
            }
        }
    }
}
