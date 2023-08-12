//
//  AlertViewController.swift
//  Winey
//
//  Created by 고영민 on 2023/08/05.
//

import UIKit
import SnapKit
import Moya
import DesignSystem

final class AlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UI Components
    
    private let tableView = UITableView()
    private let navigationBar = WINavigationBar(leftBarItem: .back)
    private lazy var safearea = self.view.safeAreaLayoutGuide
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    // MARK: - Function
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AlertCell.identifier,
            for: indexPath
        ) as? AlertCell else {return UITableViewCell()}
        cell.configure()
        return cell
    }
}

extension AlertViewController {
    private func setUI() {
        view.backgroundColor = .winey_gray0
        navigationBar.hideBottomSeperatorView = false
        navigationBar.title = "알림"
        
        tableView.register(AlertCell.self, forCellReuseIdentifier: AlertCell.identifier)
        tableView.rowHeight = 72
        tableView.backgroundColor = .winey_gray0
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setLayout() {
        view.addSubviews(navigationBar,tableView)
        
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
