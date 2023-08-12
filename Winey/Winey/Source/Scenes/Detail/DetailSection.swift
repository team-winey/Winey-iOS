//
//  DetailSection.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/08.
//

import Foundation

enum DetailType: Hashable {
    case info
    case comments
}

struct DetailSection: Hashable {
    typealias Item = DetailSectionItem
    
    let type: DetailType
    let items: [Item]
}

enum DetailSectionItem: Hashable {
    case info(DetailInfoCell.ViewModel)
    case comment(CommentCell.ViewModel)
    case emptyComment
}
