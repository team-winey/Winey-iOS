//
//  Date+.swift
//  Winey
//
//  Created by 김인영 on 2023/07/05.
//

import UIKit
import Foundation

extension Date {
    
    func getTodayDateToString(_ format: String) -> String {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let today = dateFormatter.string(from: Date())
        return today
    }
}
