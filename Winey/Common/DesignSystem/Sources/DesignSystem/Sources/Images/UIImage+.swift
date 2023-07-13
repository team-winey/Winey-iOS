//
//  ImageLiterals.swift
//  DesignSystem
//
//  Created by 김인영 on 2023/07/06.
//

import UIKit

public extension UIImage {

    enum Icon {
        public static let feed         = UIImage(named: "ic_feed")
        public static let recommend    = UIImage(named: "ic_recommend")
        public static let mypage       = UIImage(named: "ic_mypage")
        public static let more = UIImage(named: "ic_more")
        public static let like_unselected = UIImage(named: "ic_like_unselected")
        public static let like_selected = UIImage(named: "ic_like_selected")
    }
    
    enum Sample {
        public static let temp = UIImage(named: "sample1")
    }
}
