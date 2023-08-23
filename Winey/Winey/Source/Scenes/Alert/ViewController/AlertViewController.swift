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
   let notiID: Int
   let notiReceiver, notiMessage, notiType: String
   let isChecked: Bool
   let timeAgo, createdAt: String
   let linkID: Int?
}

final class AlertViewController: UIViewController {

    // MARK: - Properties
    
    var completionHandler: (()->Void)?
    
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
        setAddtarget()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTotalAlert()
    }
    override func viewWillDisappear(_ animated: Bool) {
        model = []
    }
    
    private func setAddtarget() {
        navigationBar.leftButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
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
        pushState(at: model[indexPath.row])
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
            switch response.code {
                        case 200..<300:
                            var newArray = model
                            for i in data.getNotiResponseDtoList {
                                newArray.append(Category(
                                    notiID: i.notiID,
                                    notiReceiver: i.notiReceiver,
                                    notiMessage: i.notiMessage,
                                    notiType: i.notiType,
                                    isChecked: i.isChecked,
                                    timeAgo: i.timeAgo,
                                    createdAt: i.createdAt,
                                    linkID: i.linkID )
                                )
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
    
    func pushState(at data: Category) {
        switch data.notiType {
        case "HOWTOLEVELUP":
            let guideViewController = GuideViewController()
            navigationController?.pushViewController(guideViewController, animated: true)
            
        case "COMMENTNOTI", "LIKENOTI":
            let detailViewController = DetailViewController(feedId: data.linkID ?? 0)
            detailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailViewController, animated: true)
            
        case "RANKUPTO2", "RANKUPTO3", "RANKUPTO4",
            "DELETERANKDOWNTO1", "DELETERANKDOWNTO2", "DELETERANKDOWNTO3", "GOALFAILED":
            completionHandler?()
            navigationController?.popViewController(animated: true)
            
        default:
            return
        }
    }
}
