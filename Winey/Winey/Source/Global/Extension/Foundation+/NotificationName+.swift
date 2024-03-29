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
    /// 피커에서 이미지 선택됐을때 노티
    static let whenImgSelected = Notification.Name(rawValue: "whenImgSelected")
    /// 앱이 foreground로 넘어왔을때 전달하는 노티
    static let whenEnterForeground = Notification.Name(rawValue: "whenEnterForeground")
    /// 마이피드에서 피드 삭제후 노티
    static let whenDeleteFeedCompletedInMyFeed = Notification.Name(rawValue: "whenDeleteFeedCompletedInMyFeed")
    /// 피드에서 삭제된 피드로 들어갔을 경우
    static let whenMeetDeletedFeed = Notification.Name(rawValue: "whenMeetDeletedFeed")
    /// 좋아요 눌렀을 경우
    static let whenLikeButtonDidTap = Notification.Name(rawValue: "whenLikeButtonDidTap")
}
