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
        public static let upload_photo      = UIImage(name: "upload_photo")
        public static let next              = UIImage(name: "ic_next")
        public static let danger            = UIImage(name: "ic_danger")
        public static let floating          = UIImage(name: "btn_floating")
        public static let link              = UIImage(name: "ic_link")
    }

    enum Mypage {
        public static let info = UIImage(name: "ic_info")
        public static let progressbar = UIImage(name: "level_progressbar")
        public static let pen = UIImage(name: "ic_pen")
        public static let next = UIImage(name: "ic_next")
        public static let bubble = UIImage(name: "img_bubble")
        public static let guide1 = UIImage(name: "img_guide1")
        public static let guide2 = UIImage(name: "img_guide2")
    }
    
    enum Sample {
        public static let sample1 = UIImage(name: "sample1")
    }
    
    enum Img {
        public static let appbar_logo = UIImage(name: "appbar_logo")
        public static let mypage_level_one = UIImage(name: "img_mypage_level_one")
        public static let mypage_level_two = UIImage(name: "img_mypage_level_two")
        public static let mypage_level_three = UIImage(name: "img_mypage_level_three")
        public static let mypage_level_four = UIImage(name: "img_mypage_level_four")
        public static let progressbar_level_one = UIImage(name: "img_progressbar_level_one")
        public static let progressbar_level_two = UIImage(name: "img_progressbar_level_two")
        public static let progressbar_level_three = UIImage(name: "img_progressbar_level_three")
        public static let progressbar_level_four = UIImage(name: "img_progressbar_level_four")
        public static let loading_arrow = UIImage(name: "img_loading_arrow")
    }
    
    enum Btn {
        public static let close     = UIImage(name: "btn_close")
        public static let back      = UIImage(name: "btn_back")
        public static let floating  = UIImage(name: "btn_floating")
    }
}

extension UIImage {
    convenience init?(name: String) {
        self.init(named: name, in: .module, with: nil)
    }
}

extension UIImage {
   public func resizing(width: CGFloat, height: CGFloat) -> UIImage {
       let size = CGSize(width: width, height: height)
       let render = UIGraphicsImageRenderer(size: size)
       let renderImage = render.image { context in
           self.draw(in: CGRect(origin: .zero, size: size))
       }
       return renderImage
   }
    
    public func resizeWithWidth(width: CGFloat) -> UIImage? {
         let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
         imageView.contentMode = .scaleAspectFit
         imageView.image = self
         UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
         guard let context = UIGraphicsGetCurrentContext() else { return nil }
         imageView.layer.render(in: context)
         guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
         UIGraphicsEndImageContext()
         return result
     }
}
