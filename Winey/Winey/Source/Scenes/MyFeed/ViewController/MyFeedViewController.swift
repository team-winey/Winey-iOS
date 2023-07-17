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
    }
    
    private func register() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.className)
    }
    
    private func setupDataSource() {
        let cellRegistration = CellRegistration<FeedCell, FeedModel> { cell, indexPath, model  in
            cell.configure(model: Self.itemdummy[indexPath.item])
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
        snapshot.appendItems(Self.itemdummy)
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

extension MyFeedViewController {
    static var itemdummy: [FeedModel] {
        [
            FeedModel(
                id: 1,
                nickname: "뇽잉깅",
                title: "가갸거거갸갸거갸거갸거갸걱 갸거갸ㅓ갸거갸ㅓㄱ 거갸거갸ㅓ갸갸거 거갸",
                image: "hahahaha",
                money: 10000,
                like: 23,
                isLiked: true,
                writerLevel: 2
            ),
            FeedModel(
                id: 2,
                nickname: "뇽잉깅",
                title: "안녕하세요 처음 만난 사람들도 안녕하세요 하이헬로우하하하하",
                image: "hahahaha",
                money: 10000,
                like: 23,
                isLiked: true,
                writerLevel: 2
            ),
            FeedModel(
                id: 3,
                nickname: "뇽잉깅",
                title: "띄어쓰기가없는경우 띄어쓰기가없는경우 띄어쓰기가없는경우 우하하하",
                image: "hahahaha",
                money: 100000,
                like: 23,
                isLiked: false,
                writerLevel: 2
            ),
            FeedModel(
                id: 4,
                nickname: "뇽잉깅",
                title: "가갸거거갸갸거갸거갸거갸걱 갸거갸ㅓ갸거갸ㅓㄱ 거갸거갸ㅓ갸갸거 거갸",
                image: "hahahaha",
                money: 1000,
                like: 23,
                isLiked: true,
                writerLevel: 2
            )
        ]
    }
}
