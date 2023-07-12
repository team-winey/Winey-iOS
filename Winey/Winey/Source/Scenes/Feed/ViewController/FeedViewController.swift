//
//  FeedViewController.swift
//  Winey
//
//  Created by 김인영 on 2023/07/10.
//

import UIKit

import SnapKit

final class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    var dataSource : UICollectionViewDiffableDataSource<Int, FeedModel>!
    
    // MARK: - UI Components
    
    private let naviBar = UIView()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setFlowLayout())
        collectionView.backgroundColor = .winey_gray100
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        return collectionView
    }()
    private lazy var writeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .winey_yellow
        button.setImage(.Icon.write, for: .normal)
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
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.className)
        collectionView.register(FeedCollectionReusableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeedCollectionReusableHeaderView.className)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, FeedModel>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.className, for: indexPath) as! FeedCollectionViewCell
            cell.setData(model: itemdummy[indexPath.item])
            return cell
        }
        dataSource.apply(snapshot(), animatingDifferences: false)
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FeedCollectionReusableHeaderView.className, for: indexPath) as? FeedCollectionReusableHeaderView else { return nil }
            return header
        }
    }
    
    private func snapshot() -> NSDiffableDataSourceSnapshot<Int, FeedModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, FeedModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(itemdummy)
        return snapshot
    }
    
    private func setFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 367)
        layout.minimumLineSpacing = 1
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(view.frame.width), heightDimension: .absolute(80))
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 188)
        layout.sectionHeadersPinToVisibleBounds = false
        return layout
    }
}

// MARK: - UI & Layout

extension FeedViewController {
    private func setLayout() {
        view.addSubviews(naviBar, collectionView, writeButton)
        
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
        
        writeButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(23)
            $0.size.equalTo(56)
        }
    }
}

// MARK: - CollectionViewDelegate

extension FeedViewController: UICollectionViewDelegate {}
