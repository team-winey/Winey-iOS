//
//  NotificationName+.swift
//  Winey
//
//  Created by Woody Lee on 2023/07/20.
//

import Foundation

extension Notification.Name {
    /// 피드 업로드가 완료되었을때 노티
    static let whenFeedUploaded = Notification.Name(rawValue: "whenFeedUploaded")
    /// 목표설정 완료되었을때 노티
    static let whenSetGoalCompleted = Notification.Name(rawValue: "whenSetGoalCompleted")
    /// 피드 업로드후 노티
    static let whenUploadFeedCompleted = Notification.Name(rawValue: "whenUploadFeedCompleted")
    /// 피드 업로드 성공여부 노티
    static let feedUploadResult = Notification.Name(rawValue: "feedUploadResult")
    /// 피드 삭제후 노티
    static let whenDeleteFeedCompleted = Notification.Name(rawValue: "whenDeleteFeedCompleted")
    static let whenImgSelected = Notification.Name(rawValue: "whenImgSelected")
    static let imgLoadingEnd = Notification.Name(rawValue: "imgLoadingEnd")
}
