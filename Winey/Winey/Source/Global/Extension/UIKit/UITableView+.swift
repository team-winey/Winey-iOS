//
//  UITableView+.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/09.
//

import UIKit

extension UITableView {
    func dequeue<Cell: UITableViewCell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell? {
        let identifier = String(describing: cellType)
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell
    }
    
    func registerCell<Cell: UITableViewCell>(_ cellType: Cell.Type) {
        let identifier = String(describing: cellType)
        self.register(cellType, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooter<HeaderFooter: UITableViewHeaderFooterView>(_ headerFooterType: HeaderFooter.Type) {
        let identifier = String(describing: headerFooterType)
        self.register(headerFooterType, forHeaderFooterViewReuseIdentifier: identifier)
    }
}

