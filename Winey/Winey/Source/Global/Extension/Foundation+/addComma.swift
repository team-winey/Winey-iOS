//
//  addComma.swift
//  Winey
//
//  Created by 김인영 on 2023/07/11.
//

import Foundation

/// 천 단위마다 ,표시
func addComma(value: Int) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let result = numberFormatter.string(from: NSNumber(value: value)) ?? ""
    
    return result + "원"
}
