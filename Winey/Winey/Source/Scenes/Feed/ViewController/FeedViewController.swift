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
    
    private func register() {
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.className)
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, FeedModel>(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.className, for: indexPath) as! FeedCollectionViewCell
            cell.dataBind(model: itemdummy[indexPath.item])
            return cell
        }
        dataSource.apply(snapshot(), animatingDifferences: false)
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
        return layout
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        register()
        setupDataSource()
    }
}

// MARK: - UI & Layout

extension FeedViewController {
    private func setLayout() {
        view.addSubviews(naviBar, collectionView)
        
        naviBar.backgroundColor = .winey_purple400
        
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

// MARK: - CollectionViewDelegate

extension FeedViewController: UICollectionViewDelegate {}
