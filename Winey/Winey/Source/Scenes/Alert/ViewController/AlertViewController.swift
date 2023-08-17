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

struct Category {
    let notiType: String
    let notiMessage: String
    let timeago: String
}

final class AlertViewController: UIViewController {


    // MARK: - Properties
    var model: [Category] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var notiType: String?
    private var notiMessage: String?
    private var timeago: String?
    private let alertService = NotificationService()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTotalAlert()
    }
}
// MARK: - Function

extension AlertViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AlertCell.identifier,
            for: indexPath
        ) as? AlertCell else {
            return UITableViewCell()
        }

        cell.configureCell(for: model[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        pushState(at: model[indexPath.row].notiType)
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

extension AlertViewController {
    private func getTotalAlert() {
        alertService.getTotalNotification() { [weak self] response in
            guard let response = response, let data = response.data else { return }

            guard let self else { return }
            
//            print("444", data.getNotiResponseDtoList)

            switch response.code {
            case 200..<300:
                var newArray = model
                for i in data.getNotiResponseDtoList {
                    newArray.append(Category(notiType: i.notiMessage, notiMessage: i.notiMessage , timeago: i.timeAgo ))
                }

                model = newArray

                print("😀", data)
            case 400...500:
                print("🥰")
            default:
                print("default")
            }
        }
    }
    
    func pushState(at data: String) {
        
        switch data {
        case "위니 사용법":
            let guideViewController = GuideViewController()
            navigationController?.pushViewController(guideViewController, animated: true)
            
        case "좋아요", "댓글":
            let mypageViewController = MypageViewController()
            navigationController?.pushViewController(mypageViewController, animated: true) //서버 - > 게시글 ID
            
        case "등급 상승", "등급 하락", "목표 달성 실패":
            let mypageViewController = MypageViewController()
            navigationController?.pushViewController(mypageViewController, animated: true)
            
        default:
            return
        }
    }
}
