//
//  MyFeedViewController.swift
//  Winey
//
//  Created by 김인영 on 2023/07/12.
//

import UIKit

import DesignSystem
import SnapKit

final class MyFeedViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, FeedModel>
    private typealias CellRegistration = UICollectionView.CellRegistration
    private typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration
    
    // MARK: - Properties
    
    var dataSource : UICollectionViewDiffableDataSource<Int, FeedModel>!
    private var feedService = FeedService()
    private let feedLikeService = FeedLikeService()
    private var myfeed: [FeedModel] = []
    private var currentPage: Int = 1
    private var isEnd: Bool = false
    
    // MARK: - UI Components
    
    private lazy var naviBar: WINavigationBar = {
        let naviBar = WINavigationBar(leftBarItem: .back)
        naviBar.title = "마이피드"
        naviBar.hideBottomSeperatorView = false
        naviBar.leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        return naviBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.bounds.width, height: 367)
        layout.minimumLineSpacing = 1

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.backgroundColor = .winey_gray100
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        register()
        setupDataSource()
        getMyFeed(page: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setUI() {
        view.backgroundColor = .winey_gray0
    }
    
    private func register() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.className)
    }
    
    private func setupDataSource() {
        let cellRegistration = CellRegistration<FeedCell, FeedModel> { cell, indexPath, model  in
            cell.configure(model: self.myfeed[indexPath.item])
            cell.likeButtonTappedClosure = { [weak self] selectedFeedId, isLiked in
                self?.postFeedLike(feedId: selectedFeedId, feedLike: isLiked)
            }
            cell.moreButtonTappedClosure = { [weak self] feedId, _ in
                self?.showAlert(feedId, indexPath.item)
            }
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }
        
        dataSource.apply(snapshot(), animatingDifferences: false)
    }
    
    private func snapshot() -> NSDiffableDataSourceSnapshot<Int, FeedModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FeedModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.myfeed)
        return snapshot
    }
    
    private func showAlert(_ idx: Int, _ path: Int) {
        
        let alertContent = MIPopupContent(
            title: "진짜 게시물을 삭제하시겠어요?",
            subtitle: "지금 게시물을 삭제하면 누적 금액이 \n 삭감되어 레벨이 내려갈 수 있으니 주의하세요!"
        )
        
        let alertController = MIPopupViewController(content: alertContent)
        
        alertController.addButton(title: "취소", type: .gray) { [weak self] in
            self?.dismiss(animated: true)
        }
        
        alertController.addButton(title: "삭제하기", type: .yellow) { [weak self] in
            DispatchQueue.global(qos: .userInteractive).async {
                self?.deleteMyFeed(idx: idx)
            }
            
            self?.deleteCell(path)
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func refresh() {
        myfeed = []
        currentPage = 1
        
        getMyFeed(page: currentPage)
    }
    
    private func getMoreFeed() {
        self.currentPage += 1
        self.getMyFeed(page: self.currentPage)
    }
    
    func deleteCell(_ path: Int) {
        var snapshot = dataSource.snapshot()
        let targetItem = snapshot.itemIdentifiers[path]
        snapshot.deleteItems([targetItem])
        dataSource.apply(snapshot)
        myfeed.remove(at: path)
    }
    
    @objc private func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UI & Layout

extension MyFeedViewController {
    private func setLayout() {
        
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

// MARK: - CollectionViewDelegate

extension MyFeedViewController: UICollectionViewDelegate {}

extension MyFeedViewController: UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == myfeed.count - 2 {
            getMoreFeed()
        }
    }
}
extension MyFeedViewController {
    private func getMyFeed(page: Int) {
        feedService.getMyFeed(page: page) { [weak self] response in
            guard let response = response, let data = response.data else { return }
            guard let self else { return }
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
                    profileImage: userLevel.profileImage
                )
                self.myfeed.append(feed)
                self.myfeed = myfeed.removeDuplicates()
            }
           
            var newSnapshot = NSDiffableDataSourceSnapshot<Int, FeedModel>()
            newSnapshot.appendSections([0])
            newSnapshot.appendItems(self.myfeed)
            
            self.dataSource.apply(newSnapshot, animatingDifferences: true)
        }
    }
    
    private func deleteMyFeed(idx: Int) {
        feedService.deleteMyFeed(idx) { _ in }
    }
    
    private func postFeedLike(feedId: Int, feedLike: Bool) {
        feedLikeService.postFeedLike(feedId: feedId, feedLike: feedLike) { [weak self] response in
            guard let response = response, let data = response.data else { return }
            guard let self = self else { return }
            if let feedIndex = self.myfeed.firstIndex(where: { $0.feedId == feedId }) {
                self.myfeed[feedIndex].isLiked = feedLike
                self.myfeed[feedIndex].like = data.likes
            }
            self.dataSource.apply(self.snapshot(), animatingDifferences: false)
        }
    }
}

private extension Sequence where Element: Hashable {
    func removeDuplicates() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
