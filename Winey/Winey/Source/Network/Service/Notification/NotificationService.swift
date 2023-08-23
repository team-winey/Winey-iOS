//
//  NotificationService.swift
//  Winey
//
//  Created by 고영민 on 2023/08/16.
//

import Foundation

import Moya

final class NotificationService {
    let notificationProvider = CustomMoyaProvider<NotificationAPI>(session: Session(interceptor: SessionInterceptor.shared))

    init() { }

    private(set) var totalNotificationData:
    BaseResponse<TotalNotificationResponse>?

    private(set) var checkNewNotificationData: Bool?
    
    // 1. 알림 전체 조회
    
    func getTotalNotification(completion: @escaping (BaseResponse<TotalNotificationResponse>?) -> Void) {
        notificationProvider.request(.getTotalNotification) { [self] (result) in
            print("😀😀😀😀😀😀😀", result)
            switch result {
            case .success(let response):
                do {
                    self.totalNotificationData = try response.map(BaseResponse<TotalNotificationResponse>.self)
                    print("❤️❤️❤️❤️❤️❤️❤️", totalNotificationData)
                    completion(totalNotificationData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. 알림 확인 여부 조회
    
    func getNewNotificationStatus(completion: @escaping (Bool) -> Void) {
        notificationProvider.request(.getNewNotificationStatus) { (result) in
            switch result {
            case .success(let response):
                do {
                    let responseData = try response.map(BaseResponse<CheckNewNotificationResponse>.self)
                    if let checkNewNotificationData = responseData.data?.hasNewNotification {
                        self.checkNewNotificationData = checkNewNotificationData
                        completion(checkNewNotificationData)
                    }
                } catch let error {
                    print(error.localizedDescription)
                    completion(false)
                }
            case .failure(let err):
                print(err)
                completion(false)
            }
        }
    }
}
