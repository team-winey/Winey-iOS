//
//  NotificationViewController.swift
//  Winey
//
//  Created by 고영민 on 2023/08/05.
//

import UIKit
import SnapKit
import Moya
import DesignSystem

final class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - UI Components
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let navigationBar = WINavigationBar.init(title: "알림")
    private lazy var safearea = self.view.safeAreaLayoutGuide
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    // MARK: - Function
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as? NotificationCell else { return UITableViewCell()}
        cell.configure()
        return cell
    }
}

extension NotificationViewController {
    private func setUI() {
        navigationBar.hideBottomSeperatorView = false
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        tableView.rowHeight = 55
        tableView.backgroundColor = .blue
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setLayout() {
        view.addSubviews(navigationBar,tableView)
        
        view.backgroundColor = .red
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safearea)
            $0.horizontalEdges.equalToSuperview()
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
