//
//  File.swift
//  
//
//  Created by Woody Lee on 2023/07/14.
//

import Foundation

public struct MIPopupContent {
    public var title: String
    public var subtitle: String?
    
    public init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
}
