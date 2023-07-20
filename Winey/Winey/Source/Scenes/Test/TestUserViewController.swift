//
//  TestUserViewController.swift
//  Winey
//
//  Created by Woody Lee on 2023/07/20.
//

import UIKit

import DesignSystem

class TestUserViewController: UIViewController {
    private let tableView = UITableView()
    private var userIds: [Int] = (1..<21).map { $0 }
    private var selectedUserId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedUserId = UserSingleton.getId()
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension TestUserViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
    
        var content = cell.defaultContentConfiguration()
        content.attributedText = Typography.build(
            string: "\(userIds[indexPath.row])",
            attributes: .init(style: .detail, weight: .bold, textColor: .winey_gray900)
        )
        let image: UIImage? = userIds[indexPath.row] == selectedUserId
        ? UIImage(systemName: "checkmark")
        : nil
        
        content.image = image
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userId = userIds[indexPath.row]
        UserSingleton.saveId(userId)
        
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0) 
        }
    }
}
