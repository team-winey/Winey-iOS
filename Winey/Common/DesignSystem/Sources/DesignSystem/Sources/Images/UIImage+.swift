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
    }
    
    enum Mypage{
        static let info = UIImage(named: "ic_info")
        static let progressbar = UIImage(named: "level_progressbar")
        static let pen = UIImage(named: "ic_pen")
        static let next = UIImage(named: "ic_next")
    }
}
