//
//  CustomMoyaProvider.swift
//  Winey
//
//  Created by 김인영 on 2023/07/19.
//

import Foundation

import Moya

class CustomMoyaProvider<Target: TargetType>: MoyaProvider<Target> {
    convenience init() {
        let plugins: [PluginType] = [MoyaLoggerPlugin()]
        let session = Session(interceptor: SessionInterceptor())
        self.init(session: session, plugins: plugins)
    }
}
