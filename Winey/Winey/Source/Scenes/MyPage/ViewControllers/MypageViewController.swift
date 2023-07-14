//
//  MypageViewController.swift
//  Winey
//
//  Created by 고영민 on 2023/07/12.
//

import UIKit

import SnapKit

final class MypageViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setUI()
    }
    
    private func setUI() {
        collectionView.backgroundColor = .winey_gray200
        collectionView.register(MypageProfileCell.self, forCellWithReuseIdentifier: MypageProfileCell.identifier)
        collectionView.register(MypageGoalInfoCell.self, forCellWithReuseIdentifier: MypageGoalInfoCell.identifier)
        collectionView.register(MyfeedCollectionViewCell.self, forCellWithReuseIdentifier: MyfeedCollectionViewCell.identifier)
        collectionView.register(InquiryCollectionViewCell.self, forCellWithReuseIdentifier: InquiryCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension MypageViewController: UICollectionViewDelegate {}

extension MypageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let MypageGoalInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageGoalInfoCell.identifier, for: indexPath) as? MypageGoalInfoCell else { return UICollectionViewCell()}
        
        guard let SetupCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyfeedCollectionViewCell.identifier, for: indexPath) as? MyfeedCollectionViewCell else { return UICollectionViewCell()}
        
        guard let InquiryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: InquiryCollectionViewCell.identifier, for: indexPath) as? InquiryCollectionViewCell else { return UICollectionViewCell()}
        
        switch indexPath.section {
        case 0 :
            guard let MypageProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: MypageProfileCell.identifier, for: indexPath) as? MypageProfileCell else { return UICollectionViewCell()}
            
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0: return CGSize(width: (UIScreen.main.bounds.width), height: 339)
        case 1: return CGSize(width: (UIScreen.main.bounds.width), height: 174)
        case 2: return CGSize(width: (UIScreen.main.bounds.width), height: 55)
        case 3: return CGSize(width: (UIScreen.main.bounds.width), height: 55)
        default : return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
}
