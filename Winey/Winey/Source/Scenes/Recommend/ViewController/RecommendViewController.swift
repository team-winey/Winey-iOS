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
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, RecommendModel>
    private typealias CellRegistration = UICollectionView.CellRegistration
    private typealias SupplementaryRegistration = UICollectionView.SupplementaryRegistration
    
    // MARK: - Properties
    
    var dataSource : UICollectionViewDiffableDataSource<Int, RecommendModel>!
    
    // MARK: - UI Components
    
    private let naviBar = UIView()
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
        let cellRegistration = CellRegistration<RecommendCell, RecommendModel> { cell, indexPath, model  in
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
    
    private func snapshot() -> NSDiffableDataSourceSnapshot<Int, RecommendModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RecommendModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(Self.itemdummy)
        return snapshot
    }
}

// MARK: - UI & Layout

extension RecommendViewController {
    private func setLayout() {
        view.addSubviews(naviBar, collectionView)
        
        naviBar.backgroundColor = .winey_purple400
        
        naviBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension RecommendViewController: UICollectionViewDelegate {}

extension RecommendViewController {
    static var itemdummy: [RecommendModel] {
        [
            RecommendModel(
                id: 1,
                link: "link",
                title: "타이틀1",
                subTitle: "서브타이틀",
                discount: "1000원 절약",
                image: UIImage()
            ),
            RecommendModel(
                id: 2,
                link: "link",
                title: "타이틀2",
                subTitle: "서브타이틀",
                discount: "1000원 절약",
                image: UIImage()
            ),
            RecommendModel(
                id: 3,
                link: "link",
                title: "서울시\n지원해줘",
                subTitle: "서브타이틀",
                discount: "100000원 절약",
                image: UIImage()
            ),

        ]
    }
}
