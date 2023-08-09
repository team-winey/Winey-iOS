//
//  AlertModel.swift
//  Winey
//
//  Created by 고영민 on 2023/08/08.
//

import UIKit

struct Alert {
    let image: UIImage
    let kind: String
    let content: Content // TODO: 이미자하고 텍스트가 바뀜
    let elapsedTime: String
}

extension Alert {
    static func dummy() -> [Alert] {
        return [Alert(image: .Icon.like!,
                      kind: "좋아요",
                      content: .levelup,
                      elapsedTime: "10분전"),
                Alert(image: .Icon.like!,
                      kind: "좋아요",
                      content: .levelup,
                      elapsedTime: "10분전"),
                Alert(image: .Icon.like!,
                      kind: "좋아요",
                      content: .levelup,
                      elapsedTime: "10분전"),
                Alert(image: .Icon.like!,
                      kind: "좋아요",
                      content: .levelup,
                      elapsedTime: "10분전"),
                Alert(image: .Icon.like!,
                      kind: "좋아요",
                      content: .levelup,
                      elapsedTime: "10분전"),
                Alert(image: .Icon.like!,
                      kind: "좋아요",
                      content: .levelup,
                      elapsedTime: "10분전"),
                Alert(image: .Icon.like!,
                      kind: "좋아요",
                      content: .levelup,
                      elapsedTime: "10분전")]
    }
}
