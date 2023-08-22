//
//  NotificationAPI.swift
//  Winey
//
//  Created by 고영민 on 2023/08/16.
//

import Foundation

import Moya

enum NotificationAPI {
    case getTotalNotification
    case getNewNotificationStatus
    case patchCheckAllNotification
}

extension NotificationAPI: TargetType {
    
    var authorizationType: Moya.AuthorizationType? {
        switch self {
        default:
            return nil
        }
    }
    
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
           switch self {
           case .getTotalNotification:
               return URLConstant.notification
           case .getNewNotificationStatus:
               return URLConstant.notification + "/check"
           case .patchCheckAllNotification:
               return URLConstant.notification
           }
       }

       var method: Moya.Method {
           switch self {
           case .getTotalNotification, .getNewNotificationStatus:
               return .get
           case .patchCheckAllNotification:
               return .patch
           }
       }

       var task: Moya.Task {
           switch self {
           case .getTotalNotification, .getNewNotificationStatus, .patchCheckAllNotification :
               return .requestPlain
           }
       }

       var headers: [String : String]? {
           switch self {
           case .getTotalNotification, .getNewNotificationStatus, .patchCheckAllNotification:
               return NetworkConstant.defaultHeader
           }
       }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
