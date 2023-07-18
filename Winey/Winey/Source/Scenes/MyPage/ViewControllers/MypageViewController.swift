//
//  MypageViewController.swift
//  Winey
//
//  Created by 고영민 on 2023/07/12.
//

import UIKit

import SnapKit
import DesignSystem

final class MypageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - UIComponents
    
    private let navigationBar = WINavigationBar.init(title: "마이페이지")
    private lazy var safearea = self.view.safeAreaLayoutGuide
    private let topBackgroundColor = UIColor.winey_gray0
    private let bottomBackgroundColor = UIColor.winey_gray50
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setUI()
    }
    
    // MARK: - UIComponents
    
    private func setUI() {
        collectionView.backgroundColor = bottomBackgroundColor
        collectionView.register(
            MypageProfileCell.self,
            forCellWithReuseIdentifier: MypageProfileCell.identifier
        )
        collectionView.register(
            MypageGoalInfoCell.self,
            forCellWithReuseIdentifier: MypageGoalInfoCell.identifier
        )
        collectionView.register(
            MyfeedCollectionViewCell.self,
            forCellWithReuseIdentifier: MyfeedCollectionViewCell.identifier
        )
        collectionView.register(
            InquiryCollectionViewCell.self,
            forCellWithReuseIdentifier: InquiryCollectionViewCell.identifier
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        view.addSubviews(navigationBar, collectionView)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safearea)
            $0.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension MypageViewController: UICollectionViewDelegate {}

extension MypageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int {
        switch section {
        case 0, 1, 2, 3:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        
        guard let MypageGoalInfoCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MypageGoalInfoCell.identifier,
                    for: indexPath
                )
                as? MypageGoalInfoCell else { return UICollectionViewCell()}
        
        guard let SetupCollectionViewCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MyfeedCollectionViewCell.identifier,
                    for: indexPath
                )
                as? MyfeedCollectionViewCell else { return UICollectionViewCell()}
        
        guard let InquiryCollectionViewCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: InquiryCollectionViewCell.identifier,
                    for: indexPath
                )
                as? InquiryCollectionViewCell else { return UICollectionViewCell()}
        
        switch indexPath.section {
        case 0 :
            guard let MypageProfileCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: MypageProfileCell.identifier,
                        for: indexPath
                    )
                    as? MypageProfileCell else { return UICollectionViewCell()}
            
            return MypageProfileCell
        case 1 :
            return MypageGoalInfoCell
        case 2 :
            return SetupCollectionViewCell
        case 3 :
            return InquiryCollectionViewCell
            
        default :
            return UICollectionViewCell()
        }
    }
}

extension MypageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    )
    -> CGSize {
        switch indexPath.section {
        case 0: return CGSize(width: (UIScreen.main.bounds.width), height: 339)
        case 1: return CGSize(width: (UIScreen.main.bounds.width), height: 174)
        case 2: return CGSize(width: (UIScreen.main.bounds.width), height: 55)
        case 3: return CGSize(width: (UIScreen.main.bounds.width), height: 55)
        default : return .zero
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        switch section {
        case 0: return .init(top: 0, left: 0, bottom: 5, right: 0)
        case 1: return .init(top: 0, left: 0, bottom: 5, right: 0)
        case 2: return .init(top: 0, left: 0, bottom: 3, right: 0)
        case 3: return .init(top: 0, left: 0, bottom: 3, right: 0)
        default: return .zero
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 컬렉션뷰의 스크롤 위치를 확인하여 배경색을 변경하는 코드
        if scrollView.contentOffset.y <= 0 {
            // (위로 스크롤을 최대로 올린 상태)
            collectionView.backgroundColor = topBackgroundColor
        } else if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            // (아래로 스크롤을 최대로 내린 상태)
            collectionView.backgroundColor = bottomBackgroundColor
        }
    }
}
