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
    private var myfeedService = FeedService()
    private var myfeed: [FeedModel] = []
    private var currentPage: Int = 1
    private var isEnd: Bool = false
    
    // MARK: - UI Components
    
    private let naviBar: WINavigationBar = {
        let naviBar = WINavigationBar(leftBarItem: .back)
        naviBar.title = "마이피드"
        return naviBar
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 367)
        layout.minimumLineSpacing = 1

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
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
        return button
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        register()
        setupDataSource()
        getMyFeed(page: currentPage)
    }
    
    private func register() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.className)
    }
    
    private func setupDataSource() {
        let cellRegistration = CellRegistration<FeedCell, FeedModel> { cell, indexPath, model  in
            cell.configure(model: self.myfeed[indexPath.item])
            cell.moreButtonTappedClosure = { [weak self] in
                self?.showAlert()
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
    
    private func showAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            // 삭제버튼 클릭 시
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            // 취소버튼 클릭 시
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func getMoreFeed() {
        self.currentPage += 1
        self.getMyFeed(page: self.currentPage)
    }
}

// MARK: - UI & Layout

extension MyFeedViewController {
    private func setLayout() {
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
        myfeedService.getMyFeed(page: page) { [weak self] response in
            guard let response = response, let data = response.data else { return }
            guard let self else { return }
            let pageData = data.pageResponse
            var newItems: [FeedModel] = []
            self.isEnd = pageData.isEnd
            
            for feedData in data.getFeedResponseList {
                let feed = FeedModel(
                    id: feedData.feedID,
                    nickname: feedData.nickname,
                    title: feedData.title,
                    image: feedData.image,
                    money: feedData.money,
                    like: feedData.likes,
                    isLiked: feedData.isLiked,
                    writerLevel: feedData.writerLevel
                )
                self.myfeed.append(feed)
                newItems.append(feed)
            }
            print(newItems)
            var newSnapshot = self.snapshot()
            newSnapshot.appendItems(newItems, toSection: 0)
            
            DispatchQueue.global().async {
                self.dataSource.apply(newSnapshot, animatingDifferences: true)
            }
        }
    }
    
    private func deleteMyFeed(idx: Int) {
        let currentOffset = collectionView.contentOffset.y
        
        myfeedService.deleteMyFeed(idx) { [weak self] response in
            
            guard let self else { return }
            
            if response {
                getMyFeed(page: self.currentPage)
                collectionView.contentOffset.y = currentOffset
            }
        }
    }
}
