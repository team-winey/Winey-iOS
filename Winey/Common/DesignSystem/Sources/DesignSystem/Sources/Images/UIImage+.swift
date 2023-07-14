//
//  ImageLiterals.swift
//  DesignSystem
//
//  Created by 김인영 on 2023/07/06.
//

import UIKit

public extension UIImage {
    enum Icon {
        public static let feed              = UIImage(name: "ic_feed")
        public static let recommend         = UIImage(name: "ic_recommend")
        public static let mypage            = UIImage(name: "ic_mypage")
        public static let more              = UIImage(name: "ic_more")
        public static let like_unselected   = UIImage(name: "ic_like_unselected")
        public static let like_selected     = UIImage(name: "ic_like_selected")
        public static let next              = UIImage(name: "ic_next")
        public static let floating          = UIImage(name: "btn_floating")
    }
    enum Mypage{
        public static let info = UIImage(name: "ic_info")
        public static let progressbar = UIImage(name: "level_progressbar")
        public static let pen = UIImage(name: "ic_pen")
        public static let next = UIImage(name: "ic_next")
    }
    
    enum Sample {
        public static let sample1 = UIImage(name: "sample1")
    }
}

extension UIImage {
    convenience init?(name: String) {
        self.init(named: name, in: .module, with: nil)
    }
}
