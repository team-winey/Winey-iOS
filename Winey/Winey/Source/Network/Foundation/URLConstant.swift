//
//  URLConstant.swift
//  Winey
//
//  Created by 김인영 on 2023/07/17.
//

import Foundation

struct URLConstant {
    
    // MARK: - Base URL
    static let baseURL = (Bundle.main.infoDictionary?["BASE_URL"] as! String).replacingOccurrences(of: " ", with: "")
    
}
