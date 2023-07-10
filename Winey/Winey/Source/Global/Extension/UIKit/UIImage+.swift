//
//  ImageLiterals.swift
//  Winey
//
//  Created by 김인영 on 2023/07/06.
//

import UIKit

extension UIImage {

    enum TabBar {
        static let feed = UIImage(named: "ic_feed")
        static let recommend = UIImage(named: "ic_recommend")
        static let myPage = UIImage(named: "ic_mypage")
    }
    
    enum Upload {
        static let photo = UIImage(named: "upload_photo")
        static let back = UIImage(named: "upload_back")
        static let cancel = UIImage(named: "upload_cancel")
    }
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
