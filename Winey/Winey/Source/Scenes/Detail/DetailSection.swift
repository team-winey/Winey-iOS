//
//  DetailSection.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/08.
//

import Foundation

enum DetailSection: Hashable {
    typealias Item = DetailSectionItem
    
    case info(item: Item)
    case comments(items: [Item])
}

enum DetailSectionItem: Hashable {
    case info(DetailInfoCell.ViewModel)
    case comment(CommentCell.ViewModel)
}
