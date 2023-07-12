//
//  ImageLiterals.swift
//  DesignSystem
//
//  Created by 김인영 on 2023/07/06.
//

import UIKit

public extension UIImage {
    enum Icon {
        public static let feed         = UIImage(name: "ic_feed")
        public static let recommend    = UIImage(name: "ic_recommend")
        public static let mypage       = UIImage(name: "ic_mypage")
    }
}

extension UIImage {
    convenience init?(name: String) {
        self.init(named: name, in: .module, with: nil)
    }
}
