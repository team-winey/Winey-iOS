//
//  TotalAlertResponse.swift
//  Winey
//
//  Created by 고영민 on 2023/08/10.
//

import Foundation

struct TotalAlertResponse: Codable {
    let alertResponseUserDto: AlertResponseUserDto
    let alertResponseGoalDto: AlertResponseGoalDto?
}

struct Welcome: Codable {
    let code: Int
    let message: String
    let data: DataClass //Alert
}

struct DataClass: Codable {
    let notification: Notification //AlertClass
}

struct Notification: Codable {
    let notiType: Enum //Enum
    let notiUser, notiMessage: String
    let notiUserLevel: Int
    let isChecked: Bool
    
    enum Alert{
    }
}
