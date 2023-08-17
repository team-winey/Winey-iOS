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
}
