//
//  AmplitudeManager.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/23.
//

import Foundation
import Amplitude

enum AmplitudeManager {
    static func configure() {
        Amplitude.instance().defaultTracking = AMPDefaultTrackingOptions.initWithAllEnabled()
        Amplitude.instance().initializeApiKey("b8264656e8694a499362cd9bedb99c0e")
    }
    
    static func logEvent<L: LogEvent>(event: L) {
        let name = event.category.rawValue
        let parameters = event.parameters
    
        Amplitude.instance().logEvent(name, withEventProperties: parameters)
        
        #if DEBUG
        if let parameters {
            let params = parameters.compactMap { $0 }
            print("📝 \(name) \(params)")
            return
        }
        print("📝 \(name)")
        #endif
    }
}
