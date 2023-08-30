//
//  RecommendViewController.swift
//  Winey
//
//  Created by 김인영 on 2023/07/13.
//

import UIKit

import DesignSystem
import SnapKit
import Moya

import SafariServices

final class RecommendViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, RecommendModel>
    private typealias CellRegistration = UICollectionView.CellRegistration
    private typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration
    
    // MARK: - Properties
    
    var dataSource : UICollectionViewDiffableDataSource<Int, RecommendModel>!
    private let recommendService = RecommendService()
    private let notiService = NotificationService()
    private var recommendList: [RecommendModel] = []
    private var currentPage: Int = 1
    private var isEnd: Bool = false
    private var linkString: String = ""
    
    // MARK: - UI Components
    
    private let naviBar = WIMainNavigationBar()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        layout.itemSize = CGSize(width: view.bounds.width - 32, height: RecommendCell.cellHeight())
        layout.minimumLineSpacing = 16
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 154)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .winey_gray0
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupDataSource()
        getTotalRecommend(page: currentPage)
        checkNewNotification()
        alertButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkNewNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let logEvent = LogEventImpl(category: .view_recommend)
        AmplitudeManager.logEvent(event: logEvent)
    }
    
    private func setupDataSource() {
        let cellRegistration = CellRegistration<RecommendCell, RecommendModel> { [weak self] cell, indexPath, model in
            guard let self = self else { return }
            guard indexPath.item < self.recommendList.count else { return }
            cell.configure(model: self.recommendList[indexPath.item])
            cell.linkButtonTappedClosure = { [weak self] linkString in
                if let linkString, let url = URL(string: linkString) {
                    let safariViewController = SFSafariViewController(url: url)
                    self?.present(safariViewController, animated: true)
                } else {
                    let alertViewController = MIPopupViewController(
                        content: .init(title: "속았지.\n이건 링크 없지롱")
                    )
                    alertViewController.addButton(title: "닫기", type: .gray, tapButtonHandler: nil)
                    self?.present(alertViewController, animated: true)
                }
                
                let logEvent = LogEventImpl(category: .click_contents, parameters: [
                    "contents_id": model.id,
                    "screen_name": linkString ?? ""
                ])
                AmplitudeManager.logEvent(event: logEvent)
            }
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
        
        let headerRegistration = SupplementaryRegistration<RecommendHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { _, _, _ in }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }
        
        dataSource.apply(snapshot(), animatingDifferences: false)
    }
    
    private func snapshot() -> NSDiffableDataSourceSnapshot<Int, RecommendModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RecommendModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.recommendList)
        return snapshot
    }
    
    private func getMorePage() {
        self.currentPage += 1
        self.getTotalRecommend(page: self.currentPage)
    }
    
    private func alertButtonTapped() {
        naviBar.alarmButtonClosure = {[weak self] in
            let alertVC = AlertViewController()
            alertVC.completionHandler = { [weak self] in
                self?.tabBarController?.selectedIndex = 2
                print("아아")
            }
            self?.navigationController?.pushViewController(alertVC, animated: true)
            print("tapped")
        }
    }
}

// MARK: - UI & Layout

extension RecommendViewController {
    private func setLayout() {
        collectionView.backgroundColor = .winey_gray50
        view.backgroundColor = .winey_gray0
        view.addSubviews(naviBar, collectionView)
        
        naviBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - ScrollDelegate

extension RecommendViewController: UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == recommendList.count - 2 && self.isEnd == false {
            getMorePage()
        }
    }
}

extension RecommendViewController: UICollectionViewDelegate {}

// MARK: - Network

extension RecommendViewController {
    
    private func getTotalRecommend(page: Int) {
        recommendService.getTotalRecommend(page: page) { [weak self] response in
            guard let response = response, let data = response.data else { return }
            guard let self else { return }
            let pageData = data.pageResponseDto
            self.isEnd = pageData.isEnd
            
            for recommendData in data.recommendsResponseDto {
                let recommend = RecommendModel(
                    id: recommendData.recommendID,
                    link: recommendData.recommendLink,
                    title: recommendData.recommendTitle,
                    subtitle: recommendData.recommendSubtitle ?? "",
                    discount: recommendData.recommendDiscount,
                    image: recommendData.recommendImage
                )
                self.recommendList.append(recommend)
                self.recommendList = self.recommendList.removeDuplicates()
            }

            var newSnapshot = NSDiffableDataSourceSnapshot<Int, RecommendModel>()
            newSnapshot.appendSections([0])
            newSnapshot.appendItems(self.recommendList)
            
            self.dataSource.apply(newSnapshot, animatingDifferences: true)
        }
    }
    
    private func checkNewNotification() {
        notiService.getNewNotificationStatus { [weak self] hasNewNotification in
            if hasNewNotification {
                self?.naviBar.alarmStatus = .newAlarm
            } else {
                self?.naviBar.alarmStatus = .defaultAlarm
            }
        }
    }
}

private extension Sequence where Element: Hashable {
    func removeDuplicates() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
