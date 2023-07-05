//
//  URL+.swift
//  Winey
//
//  Created by 김인영 on 2023/07/05.
//

import Foundation

extension URL {
    
    /// - Description: URL에 한국어가 있는 경우, 퍼센트 문자로 치환합니다
    static func decodeURL(urlString: String) -> URL? {
        if let url = URL(string: urlString) {
            return url
        } else {
            let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString
            return URL(string: encodedString)
        }
    }
}
