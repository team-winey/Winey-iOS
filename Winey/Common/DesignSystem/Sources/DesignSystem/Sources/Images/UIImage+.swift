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
        public static let apple             = UIImage(name: "ic_apple")
        public static let kakao             = UIImage(name: "ic_kakao")
        public static let info              = UIImage(name: "ic_info")
        public static let progressbar       = UIImage(name: "level_progressbar")
        public static let pen               = UIImage(name: "ic_pen")
        public static let like              = UIImage(name: "ic_like")
        public static let comment           = UIImage(name: "ic_comment")
        public static let winey             = UIImage(name: "ic_winey")
        public static let success           = UIImage(name: "ic_success")
        public static let fail              = UIImage(name: "ic_fail")
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
        public static let appbar_logo = UIImage(name: "img_appbar_logo")
        public static let mypage_level_one = UIImage(name: "img_mypage_level_one")
        public static let mypage_level_two = UIImage(name: "img_mypage_level_two")
        public static let mypage_level_three = UIImage(name: "img_mypage_level_three")
        public static let mypage_level_four = UIImage(name: "img_mypage_level_four")
        public static let progressbar_level_one = UIImage(name: "img_progressbar_level_one")
        public static let progressbar_level_two = UIImage(name: "img_progressbar_level_two")
        public static let progressbar_level_three = UIImage(name: "img_progressbar_level_three")
        public static let progressbar_level_four = UIImage(name: "img_progressbar_level_four")
        public static let guide_character = UIImage(name: "img_guide_character")
        public static let guide_character_hand = UIImage(name: "img_guide_character_hand")
        public static let loading_arrow = UIImage(name: "img_loading_arrow")
        public static let profile_level_one = UIImage(name: "img_profile_level_one")
        public static let profile_level_two = UIImage(name: "img_profile_level_two")
        public static let profile_level_three = UIImage(name: "img_profile_level_three")
        public static let profile_level_four = UIImage(name: "img_profile_level_four")
        public static let feed_character = UIImage(name: "img_feed_character")
        public static let recommend_character = UIImage(name: "img_recommend_character")
        public static let img_empty = UIImage(name: "img_empty")
        public static let bubble = UIImage(name: "img_bubble")
        public static let guide1 = UIImage(name: "img_guide1")
        public static let guide2 = UIImage(name: "img_guide2")
        public static let commoner = UIImage(name: "img_commoner")
        public static let knight = UIImage(name: "img_knight")
        public static let noble = UIImage(name: "img_noble")
        public static let emperor = UIImage(name: "img_emperor")
        public static let img_onboarding1 = UIImage(name: "img_onboarding1")
        public static let img_onboarding2 = UIImage(name: "img_onboarding2")
        public static let img_onboarding3 = UIImage(name: "img_onboarding3")
    }
    
    enum Btn {
        public static let close     = UIImage(name: "btn_close")
        public static let back      = UIImage(name: "btn_back")
        public static let floating  = UIImage(name: "btn_floating")
        public static let btn_plus  = UIImage(name: "btn_plus")
        public static let more  = UIImage(name: "btn_more")
    }
    
    enum Login {
        public static let character = UIImage(name: "img_loginCharacter")
        public static let logo = UIImage(name: "img_loginLogo")
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
