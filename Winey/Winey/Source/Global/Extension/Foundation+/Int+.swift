//
//  Int+.swift
//  Winey
//
//  Created by 김응관 on 2023/07/14.
//

import Foundation

extension Int {
    /// 천 단위마다 ,표시
    func addCommaToString() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: self))
        return result
    }
}
