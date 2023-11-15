//
//  UIAlertViewController+.swift
//  Winey
//
//  Created by 김응관 on 2023/08/28.
//

import UIKit

extension UIAlertController {
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
}
