//
//  TestViewController.swift
//  Winey
//
//  Created by Woody Lee on 2023/07/13.
//

import UIKit

import SnapKit
import DesignSystem

// TODO: 테스트 메뉴 구성
final class TestViewController: UIViewController {
    private let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "개발자 메뉴"
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

extension TestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestMenu.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
    
        var content = cell.defaultContentConfiguration()
        content.attributedText = Typography.build(
            string: TestMenu.allCases[indexPath.row].title,
            attributes: .init(style: .detail, weight: .bold, textColor: .winey_gray900)
        )
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = TestMenu.allCases[indexPath.row].destinationViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

enum TestMenu: CaseIterable {
    case typo
    case popup
    
    var title: String {
        switch self {
        case .typo: return "디자인시스템 - 타이포그래피"
        case .popup: return "디자인시스템 - 팝업"
        }
    }
    
    var destinationViewController: UIViewController {
        switch self {
        case .typo: return TestTypoViewController()
        case .popup: return TestPopupViewController()
        }
    }
}
