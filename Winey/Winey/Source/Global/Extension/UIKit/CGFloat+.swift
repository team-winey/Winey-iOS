//
//  CGFloat+.swift
//  Winey
//
//  Created by 김인영 on 2023/07/12.
//

import UIKit

extension CGFloat {
  var adjustedW: CGFloat {
    let ratio: CGFloat = UIScreen.main.bounds.width / 390
    return self * ratio
  }
   
  var adjustedH: CGFloat {
    let ratio: CGFloat = UIScreen.main.bounds.height / 844
    return self * ratio
  }
}
