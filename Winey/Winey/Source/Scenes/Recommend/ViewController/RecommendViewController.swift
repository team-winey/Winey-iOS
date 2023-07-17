//
//  RecommendViewController.swift
//  Winey
//
//  Created by 김인영 on 2023/07/13.
//

import UIKit

import DesignSystem
import SnapKit

final class RecommendViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, RecommendFeedModel>
    private typealias CellRegistration = UICollectionView.CellRegistration
    private typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration
    
    // MARK: - Properties
    
    var dataSource : UICollectionViewDiffableDataSource<Int, RecommendFeedModel>!
    
    // MARK: - UI Components
    
    private let naviBar = WIMainNavigationBar()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width - 32, height: RecommendCell.cellHeight())
        layout.minimumLineSpacing = 16
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 154)
        
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
        register()
        setupDataSource()
    }
    
    private func register() {
        collectionView.register(RecommendCell.self, forCellWithReuseIdentifier: RecommendCell.className)
        collectionView.register(
            RecommendHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: RecommendHeaderView.className
        )
    }
    
    private func setupDataSource() {
        let cellRegistration = CellRegistration<RecommendCell, RecommendFeedModel> { cell, indexPath, model  in
            cell.configure(model: Self.itemdummy[indexPath.item])
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
    
    private func snapshot() -> NSDiffableDataSourceSnapshot<Int, RecommendFeedModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RecommendFeedModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(Self.itemdummy)
        return snapshot
    }
}

// MARK: - UI & Layout

extension RecommendViewController {
    private func setLayout() {
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

extension RecommendViewController: UICollectionViewDelegate {}

extension RecommendViewController {
    static var itemdummy: [RecommendFeedModel] {
        [
            RecommendFeedModel(
                id: 1,
                link: "서울시 청년 대중교통비 지원 사업",
                title: "타이틀1",
                subtitle: "서브타이틀",
                discount: "1000원 절약",
                image: UIImage()
            ),
            RecommendFeedModel(
                id: 2,
                link: "서울시 청년 대중교통비 지원 사업",
                title: "타이틀2",
                subtitle: "서브타이틀",
                discount: "1000원 절약",
                image: UIImage()
            ),
            RecommendFeedModel(
                id: 3,
                link: "서울시 청년 대중교통비 지원 사업",
                title: "서울시\n지원해줘",
                subtitle: "서브타이틀",
                discount: "100000원 절약",
                image: UIImage()
            ),
            RecommendFeedModel(
                id: 4,
                link: "서울시 청년 대중교통비 지원 사업",
                title: "서울시\n지원해줘",
                subtitle: "서브타이틀",
                discount: "100000원 절약",
                image: UIImage()
            )
        ]
    }
}
