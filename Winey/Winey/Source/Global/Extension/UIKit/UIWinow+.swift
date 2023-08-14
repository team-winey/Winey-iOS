//
//  UIWinow+.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/09.
//

import UIKit

extension UIWindow {
    static var current: UIWindow? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first
    }
}
