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
            cell.moreButtonTappedClosure = { [weak self] idx in
                self?.showAlert(idx, indexPath.item)
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
        
        alertController.addButton(title: "삭제하기", type: .yellow) { [weak self] in
            DispatchQueue.global(qos: .userInteractive).async {
                self?.deleteMyFeed(idx: idx)
            }
            
            self?.deleteCell(path)
        }
        
        alertController.addButton(title: "취소", type: .gray) { [weak self] in
            self?.dismiss(animated: true)
        }
        
        present(alertController, animated: true, completion: nil)
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
        myfeedService.deleteMyFeed(idx) { [weak self] response in
            
            guard let self else { return }
            
            if response {
                print("게시글이 삭제되었습니다")
            } else {
                print("게시글 삭제에 오류가 생겼습니다")
            }
        }
    }
}
