//
//  Amplitude+EventName.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/24.
//

import Foundation

extension AmplitudeManager {
    enum EventName: String {
        case click_contents
        case click_goalsetting
        case click_like
        case click_write_contents
        case click_homefeed_contents
        case click_button
        case click_edit_nickname
        case click_info
        case click_logout
        case click_myfeed
        
        case view_recommend
        case view_upload
        case view_onboarding
    }
}

protocol LogEvent {
    var category: AmplitudeManager.EventName { get }
    var parameters: [String: Any]? { get }
}

struct LogEventImpl: LogEvent {
    var category: AmplitudeManager.EventName
    var parameters: [String : Any]?
 
    init(category: AmplitudeManager.EventName, parameters: [String : Any]? = nil) {
        self.category = category
        self.parameters = parameters
    }
}
