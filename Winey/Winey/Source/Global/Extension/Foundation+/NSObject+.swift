//
//  NSObject+.swift
//  Winey
//
//  Created by 김인영 on 2023/07/05.
//

import UIKit

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
