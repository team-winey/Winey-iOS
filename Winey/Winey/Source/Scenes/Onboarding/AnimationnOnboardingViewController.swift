//
//  AnimationnOnboardingViewController.swift
//  Winey
//
//  Created by 김인영 on 2023/08/17.
//

import UIKit

import DesignSystem
import Lottie
import SnapKit


class AnimationOnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private var onboardingData: [AnimationOnboardingDataModel] = []
    private var currentPage: Int = 0
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(.Icon.arrow, for: .normal)
        button.layer.cornerRadius = 28
        button.backgroundColor = .winey_yellow
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setOnboardingData()
        setCollectionViewCell()
    }
    
    private func setCollectionViewCell() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(AnimationOnboardingCell.self, forCellWithReuseIdentifier: AnimationOnboardingCell.className)
    }
    
    private func setOnboardingData() {
        onboardingData.append(contentsOf: [
            AnimationOnboardingDataModel(
                chatImage: .Img.chat1 ?? UIImage(),
                animationView: AnimationView.onboardingView1,
                page: 1,
                subtitle: "세이버 쫓겨나는 중..."
            ),
            AnimationOnboardingDataModel(
                chatImage: .Img.chat2 ?? UIImage(),
                animationView: AnimationView.onboardingView2,
                page: 2,
                subtitle: "세이버 상황 파악 중..."
            ),
            AnimationOnboardingDataModel(
                chatImage: .Img.chat3 ?? UIImage(),
                animationView: AnimationView.onboardingView3,
                page: 3,
                subtitle: "세이버 우는 중..."
            )
        ])
    }
    
    // MARK: - @objc
    
    @objc
    private func nextButtonTapped() {
        if currentPage == onboardingData.count - 1 {
            // 마지막 페이지인 경우
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension AnimationOnboardingViewController {
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        view.backgroundColor = .winey_gray0
        view.addSubviews(collectionView, nextButton)
        
        collectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(56)
        }
    }
}

// MARK: - CollectionView Delegate & DataSource

extension AnimationOnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnimationOnboardingCell.className, for: indexPath) as? AnimationOnboardingCell else { return UICollectionViewCell() }
        cell.setOnboardingData(model: onboardingData[indexPath.item])
        return cell
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension AnimationOnboardingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.view.frame.width)
        self.currentPage = page
    }
}
