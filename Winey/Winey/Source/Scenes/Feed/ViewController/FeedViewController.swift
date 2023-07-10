//
//  FeedViewController.swift
//  Winey
//
//  Created by 김인영 on 2023/07/10.
//

import UIKit

import SnapKit

struct EmptySection: Hashable {}

final class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    var dataSource : UICollectionViewDiffableDataSource<Int, FeedItem>!
    let itemdummy = [
        FeedItem(feedId: 1, nickname: "뇽잉깅", feedTitle: "절약타이틀", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
        FeedItem(feedId: 2, nickname: "뇽잉깅", feedTitle: "절약타이틀1", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
        FeedItem(feedId: 3, nickname: "뇽잉깅", feedTitle: "절약타이틀2", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
        FeedItem(feedId: 4, nickname: "뇽잉깅", feedTitle: "절약타이틀3", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
        FeedItem(feedId: 5, nickname: "뇽잉깅", feedTitle: "절약타이틀4", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1),
        FeedItem(feedId: 6, nickname: "뇽잉깅", feedTitle: "절약타이틀5", feedImage: UIImage(), feedMoney: 2000, likes: 2, isLiked: true, createdAt: Date(), writerLevel: 1)
        ]
    
    // MARK: - UI Components
    
    private let naviBar = UIView()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        return collectionView
    }()
    
    private func register() {
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.className)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<EmptySection, FeedItem>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.className, for: indexPath) as! FeedCollectionViewCell
            cell.dataBind(model: self.items[indexPath.item])
            return cell
        }
    }
    
    private func snapshot() -> NSDiffableDataSourceSnapshot<EmptySection, FeedItem> {
        var snapshot = NSDiffableDataSourceSnapshot<EmptySection, FeedItem>()
        snapshot.appendSections([EmptySection()])
        snapshot.appendItems(items)
        return snapshot
    }
    
    private func setFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: view.frame.width - 20, height: 150)
        return layout
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        register()
        setupDataSource()
        dataSource.apply(snapshot(), animatingDifferences: false)
    }
}

// MARK: - UI & Layout

extension FeedViewController {
    private func setLayout() {
        view.addSubviews(naviBar, collectionView)
        
        naviBar.backgroundColor = .winey_purple400
        collectionView.backgroundColor = .winey_gray300
        
        naviBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension FeedViewController: UICollectionViewDelegate {}
