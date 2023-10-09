//
//  FeedViewController.swift
//  Winey
//
//  Created by 김인영 on 2023/07/10.
//

import Combine
import UIKit

import DesignSystem
import Moya
import WebKit
import SnapKit
import SafariServices

final class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, FeedModel>
    private typealias CellRegistration = UICollectionView.CellRegistration
    private typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration
    
    var dataSource : UICollectionViewDiffableDataSource<Int, FeedModel>!
    private let feedService = FeedService()
    private let feedLikeServie = FeedLikeService()
    private let notiService = NotificationService()
    private var feedList: [FeedModel] = []
    private var currentPage: Int = 1
    private var isEnd: Bool = false
    
    private var feedDeletePublisher = PassthroughSubject<Void, Never>()
    private var bag = Set<AnyCancellable>()
    
    private var currentBannerType: BannerState = .initial
    
    // MARK: - UI Components
    
    private let naviBar = WIMainNavigationBar()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 438)
        layout.minimumLineSpacing = 1
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 134)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .winey_gray0
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        return collectionView
    }()
    private lazy var writeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .winey_yellow
        button.setImage(.Btn.floating, for: .normal)
        button.makeCornerRound(radius: 28)
        button.makeShadow(radius: 10, offset: .init(width: 4, height: 4), opacity: 0.4)
        return button
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupDataSource()
        setupRefreshControl()
        getTotalFeed(page: currentPage)
        setAddTarget()
        bind()
        checkNewNotification()
        alertButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkNewNotification()
        showTabBar()
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let logEvent = LogEventImpl(category: .view_homefeed)
        AmplitudeManager.logEvent(event: logEvent)
    }
    
    private func showTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupDataSource() {
        let cellRegistration = CellRegistration<FeedCell, FeedModel> { [weak self] cell, indexPath, model in
            guard let self = self else { return }
            guard indexPath.item < self.feedList.count else { return }
            
            cell.configure(model: self.feedList[indexPath.item])
            cell.likeButtonTappedClosure = { [weak self] selectedFeedId, isLiked in
                self?.postFeedLike(feedId: selectedFeedId, feedLike: isLiked)
            }
            cell.moreButtonTappedClosure = { [weak self] feedId, userId in
                self?.showAlert(feedId: feedId, userId: userId, item: indexPath.item)
            }
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
            
        let headerRegistration = SupplementaryRegistration<FeedHeaderView>(
                elementKind: UICollectionView.elementKindSectionHeader
        ) { view, _, _ in
            view.setState(self.currentBannerType)
            view.didTapPublisher
                .sink { [weak self] in self?.goToWebViewController(url: $0) }
                .store(in: &view.cancellables)
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
        }
        
        dataSource.apply(snapshot(), animatingDifferences: false)
    }
    
    private func snapshot() -> NSDiffableDataSourceSnapshot<Int, FeedModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FeedModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.feedList)
        return snapshot
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(didBeginRefresh),
            for: .valueChanged
        )
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func didBeginRefresh() {
        refresh()
    }
    
    private func refreshHeaderView() {
        self.currentBannerType = .refreshed
        collectionView.reloadData()
    }
    
    private func stopRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { [weak self] in
            guard let self else { return }
            guard collectionView.refreshControl?.isRefreshing == true else { return }
            collectionView.refreshControl?.endRefreshing()
            self.refreshHeaderView()
            self.checkNewNotification()
        }
    }
    
    private func showAlert(feedId: Int, userId: Int, item: Int) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            print("쫄?")
        }
        alertController.addAction(cancelAction)
        if userId == UserSingleton.getId() {
            let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
                self.setDeleteAlert(feedId, item)
            }
            alertController.addAction(deleteAction)
        } else {
            print("으딜.")
            let reportAction = UIAlertAction(title: "신고하기", style: .destructive) { _ in
                self.setReportAlert(feedId)
            }
            alertController.addAction(reportAction)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    private func showToast(_ type: WIToastType) {
        let toast = WIToastBox(toastType: type)
        
        view.addSubview(toast)
        
        toast.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(23)
            $0.height.equalTo(48)
        }
    }
    
    private func bind() {
        NotificationCenter.default.publisher(for: .whenUploadFeedCompleted)
            .map({
                $0.userInfo?["type"] as! WIToastType
            })
            .sink(receiveValue: { [weak self] type in
                self?.refresh()
                self?.showToast(type)
            })
            .store(in: &bag)
        
        NotificationCenter.default.publisher(for: .whenDeleteFeedCompleted)
            .map({
                $0.userInfo?["type"] as! WIToastType
            })
            .sink(receiveValue: { [weak self] type in
                self?.refresh()
                self?.showToast(type)
            })
            .store(in: &bag)
    }
    
    private func refresh() {
        feedList = []
        currentPage = 1
        
        getTotalFeed(page: currentPage)
    }
    
    private func getMoreFeed() {
        self.currentPage += 1
        self.getTotalFeed(page: self.currentPage)
    }
    
    private func alertButtonTapped() {
        self.naviBar.alarmButtonClosure = { [weak self] in
            let alertVC = AlertViewController()
            alertVC.completionHandler = { [weak self] in
                self?.tabBarController?.selectedIndex = 2
            }
            self?.navigationController?.pushViewController(alertVC, animated: true)
            self?.tabBarController?.tabBar.isHidden = true
            print("tapped")
        }
    }
    
    private func setAddTarget() {
        writeButton.addTarget(self, action: #selector(goToUploadPage), for: .touchUpInside)
    }
    
    private func setDeleteAlert(_ feedId: Int, _ item: Int) {
        let deletePopup = MIPopupViewController(
            content: .init(
                title: "정말 게시물을 삭제하시겠어요?",
                subtitle: "지금 게시물을 삭제하면 누적 금액이\n삭감되니 주의하세요!"
            )
        )
        deletePopup.addButton(title: "취소", type: .gray, tapButtonHandler: nil)
        
        deletePopup.addButton(title: "삭제하기", type: .yellow) {
            self.deleteMyFeed(feedId: feedId)
        }
        
        self.present(deletePopup, animated: true)
    }
    
    private func setReportAlert(_ feedId: Int) {
        let deletePopup = MIPopupViewController(
            content: .init(
                title: "신고하시겠습니까?",
                subtitle: "욕설/비하, 상업적 광고 및 판매,\n낚시/놀람/도배 글의 경우 신고할 수 있습니다."
            )
        )
        deletePopup.addButton(title: "취소", type: .gray, tapButtonHandler: nil)
        
        deletePopup.addButton(title: "신고하기", type: .yellow) {
            let url = URL(string: "https://docs.google.com/forms/d/1fymNx8ALanWWzwR4O2s8hpt76mnRClOmfDx4Vbdk2kk/edit")!
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true)
        }
        
        self.present(deletePopup, animated: true)
    }

    @objc
    private func goToUploadPage() {
        let logEvent = LogEventImpl(category: .click_write_contents)
        AmplitudeManager.logEvent(event: logEvent)
        
        guard UserSingleton.getGaol() else {
            let warningViewController = MIPopupViewController(
                content: .init(
                    title: "목표 설정 시 피드 작성이 가능해요!",
                    subtitle: "지금 마이프로필에서 간단한 목표를\n설정해보세요!"
                )
            )
            warningViewController.addButton(title: "취소", type: .gray) {
                let logEvent = LogEventImpl(category: .click_goalsetting, parameters: ["method": false])
                AmplitudeManager.logEvent(event: logEvent)
            }
            
            warningViewController.addButton(title: "설정하기", type: .yellow) { [weak self] in
                guard let viewController = self?.tabBarController?.viewControllers?[2],
                      let navigationController = viewController as? UINavigationController,
                      let mypageViewController = navigationController.viewControllers[0] as? MypageViewController
                else { return }

                mypageViewController.movedByPopupFromFeedViewController = true
                self?.tabBarController?.selectedIndex = 2

                let logEvent = LogEventImpl(category: .click_goalsetting, parameters: ["method": true])
                AmplitudeManager.logEvent(event: logEvent)
            }
            
            let logEvent = LogEventImpl(category: .view_goalsetting_popup)
            AmplitudeManager.logEvent(event: logEvent)
            
            self.present(warningViewController, animated: true)
            return
        }
        
        let vc = UINavigationController(rootViewController: UploadViewController())
        vc.setNavigationBarHidden(true, animated: false)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    private func goToWebViewController(url: URL?) {
        guard let url else { return }

        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true)
    }
}

// MARK: - UI & Layout

extension FeedViewController {
    private func setLayout() {
        view.backgroundColor = .winey_gray0
        
        view.addSubviews(naviBar, collectionView, writeButton)
        
        naviBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        writeButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(23)
            $0.size.equalTo(56)
        }
    }
}

// MARK: - CollectionViewDelegate

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemModel = dataSource.itemIdentifier(for: indexPath) else { return }
        let detailViewController = DetailViewController(feedId: itemModel.feedId)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
        let logEvent = LogEventImpl(category: .click_homefeed_contents, parameters: [
            "article_id": itemModel.feedId,
            "like_count": itemModel.like,
            "comment_count": itemModel.comments
        ])
        AmplitudeManager.logEvent(event: logEvent)
    }
}

// MARK: - ScrollDelegate

extension FeedViewController: UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == feedList.count - 2 {
            getMoreFeed()
        }
    }
    
    func scrollToTop() {
        collectionView.setContentOffset(.zero, animated: true)
        refresh()
    }
}

// MARK: - Network

extension FeedViewController {
    private func getTotalFeed(page: Int) {
        feedService.getTotalFeed(page: page) { [weak self] response in
            guard let response = response, let data = response.data else { return }
            guard let self else { return }
            
            switch response.code {
            case 200..<300:
                let pageData = data.pageResponse
                self.isEnd = pageData.isEnd
                
                for feedData in data.getFeedResponseList {
                    let userLevel = UserLevel(value: feedData.writerLevel) ?? .none
                    let feed = FeedModel(
                        feedId: feedData.feedID,
                        userId: feedData.userID,
                        nickname: feedData.nickname,
                        title: feedData.title,
                        image: feedData.image,
                        money: feedData.money,
                        like: feedData.likes,
                        isLiked: feedData.isLiked,
                        writerLevel: feedData.writerLevel,
                        profileImage: userLevel.profileImage,
                        comments: feedData.comments,
                        timeAgo: feedData.timeAgo
                    )
                    
                    self.feedList.append(feed)
                    self.feedList = self.feedList.removeDuplicates()
                }
                
                var newSnapshot = NSDiffableDataSourceSnapshot<Int, FeedModel>()
                newSnapshot.appendSections([0])
                newSnapshot.appendItems(self.feedList)
                
                self.dataSource.apply(newSnapshot, animatingDifferences: true) {
                    self.stopRefreshControl()
                }
            default:
                let vc = LoginViewController()
                self.switchRootViewController(rootViewController: vc, animated: true)
            }
        }
    }
    
    private func postFeedLike(feedId: Int, feedLike: Bool) {
        feedLikeServie.postFeedLike(feedId: feedId, feedLike: feedLike) { [weak self] response in
            guard let response = response, let data = response.data else { return }
            guard let self = self else { return }
            if let feedIndex = self.feedList.firstIndex(where: { $0.feedId == feedId }) {
                self.feedList[feedIndex].isLiked = feedLike
                self.feedList[feedIndex].like = data.likes
                
                let logEvent = LogEventImpl(category: .click_like, parameters: [
                    "article_id": feedId,
                    "from": "feed",
                    "like_count": feedLike
                ])
                AmplitudeManager.logEvent(event: logEvent)
            }
            self.dataSource.apply(self.snapshot(), animatingDifferences: false)
        }
    }
    
    private func deleteMyFeed(feedId: Int) {
        feedService.deleteMyFeed(feedId) { [weak self] response in
            guard let self = self else { return }
            response ? self.showToast(.feedDeleteSuccess) : self.showToast(.feedDeleteFail)
            self.refresh()
            // self.dataSource.apply(self.snapshot(), animatingDifferences: false)
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

