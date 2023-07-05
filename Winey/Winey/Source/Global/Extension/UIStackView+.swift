//
//  UIStackView+.swift
//  Winey
//
//  Created by 김인영 on 2023/07/05.
//

import UIKit

extension UIStackView {
    
     func addArrangedSubviews(_ views: UIView...) {
         for view in views {
             self.addArrangedSubview(view)
         }
     }
}
