//
//  FeedViewController.swift
//  Winey
//
//  Created by 김인영 on 2023/07/10.
//

import UIKit

import DesignSystem
import Moya
import SnapKit

final class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, FeedModel>
    private typealias CellRegistration = UICollectionView.CellRegistration
    private typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration
    
    var dataSource : UICollectionViewDiffableDataSource<Int, FeedModel>!
    private let feedService = FeedService()
    private var feedList: [FeedModel] = []
    private var currentPage: Int = 1
    private var isEnd: Bool = false
    
    // MARK: - UI Components
    
    private let naviBar = WIMainNavigationBar()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 367)
        layout.minimumLineSpacing = 1
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 188)
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
        return button
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setupDataSource()
        getTotalFeed(page: currentPage)
    }
    
    private func setupDataSource() {
        let cellRegistration = CellRegistration<FeedCell, FeedModel> { cell, indexPath, model  in
            guard indexPath.item < self.feedList.count else { return }
            cell.configure(model: self.feedList[indexPath.item])
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
        
        let headerRegistration = SupplementaryRegistration<FeedHeaderView>(
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
    
    private func snapshot() -> NSDiffableDataSourceSnapshot<Int, FeedModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FeedModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.feedList)
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
        self.getTotalFeed(page: self.currentPage)
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
}

// MARK: - ScrollDelegate

extension FeedViewController: UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == feedList.count - 2 {
            getMoreFeed()
        }
    }
}

// MARK: - Network

extension FeedViewController {
    
    private func getTotalFeed(page: Int) {
        feedService.getTotalFeed(page: page) { [weak self] response in
            guard let response = response, let data = response.data else { return }
            guard let pageData = response.data?.pageResponseDto else { return }
            guard let self else { return }
            
            self.isEnd = pageData.isEnd
            
            var newItems: [FeedModel] = []
            
            for data in data.getFeedResponseDtoList {
                let feed = FeedModel(
                    id: data.feedID,
                    nickname: data.nickname,
                    title: data.title,
                    image: data.image,
                    money: data.money,
                    like: data.likes,
                    isLiked: data.isLiked,
                    writerLevel: data.writerLevel
                )
                self.feedList.append(feed)
                newItems.append(feed)
            }
            
            var newSnapshot = self.snapshot()
            newSnapshot.appendItems(newItems, toSection: 0)
            
            DispatchQueue.global().async {
                self.dataSource.apply(newSnapshot, animatingDifferences: true)
            }
        }
    }
}
