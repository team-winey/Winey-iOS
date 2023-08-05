//
//  OnboardingViewController.swift
//  Winey
//
//  Created by 김인영 on 2023/08/04.
//

import UIKit

import CHIPageControl
import DesignSystem
import SnapKit

class OnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private var onboardingData: [OnboardingDataModel] = []
    
    private var currentPage: Int = 0 {
        didSet {
            pageControl.progress = Double(currentPage)
            setButtonUI()
        }
    }
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let pageControl: CHIPageControlAji = {
        let pageControl = CHIPageControlAji()
        pageControl.numberOfPages = 3
        pageControl.radius = 5
        pageControl.padding = 8
        pageControl.currentPageTintColor = .winey_purple400
        pageControl.tintColor = .winey_gray300
        return pageControl
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = .winey_purple400
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonUI()
        setLayout()
        setOnboardingData()
        setCollectionViewCell()
    }
    
    private func setCollectionViewCell() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: OnboardingCell.className)
    }
    
    private func setOnboardingData() {
        onboardingData.append(contentsOf: [
            OnboardingDataModel(
                title: "메인 피드에서 절약하는\n모습을 인증해 보세요!",
                subtitle: "나와 사람들의 절약 방법을 볼 수 있어요",
                image: .Img.img_onboarding1 ?? UIImage()
            ),
            OnboardingDataModel(
                title: "추천 피드에서\n절약법을 추천해 드릴게요!",
                subtitle: "흩어져 있는 절약법을 한눈에 볼 수 있어요",
                image: .Img.img_onboarding2 ?? UIImage()
            ),
            OnboardingDataModel(
                title: "절약 목표를 세우고 실천하며\n캐릭터를 키워보세요!",
                subtitle: "캐릭터를 통해 절약을 재밌게 실천할 수 있어요",
                image: .Img.img_onboarding3 ?? UIImage()
            )
        ])
    }
    
    // MARK: - @objc
    
    @objc
    private func nextButtonTapped() {
        if currentPage == onboardingData.count - 1 {
            // 시작하기 버튼 클릭 시
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension OnboardingViewController {
    
    private func setButtonUI() {
        let nextButtonAtrributeString = Typography.build(
            string: "다음으로",
            attributes: Const.nextButtonAttributes
        )
        let lastPageAttributeString = Typography.build(
            string: "시작하기",
            attributes: Const.nextButtonAttributes
        )
        
        if currentPage == 2 {
            nextButton.setAttributedTitle(lastPageAttributeString, for: .normal)
        } else {
            nextButton.setAttributedTitle(nextButtonAtrributeString, for: .normal)
        }
    }
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        view.backgroundColor = .winey_gray0
        view.addSubviews(pageControl, collectionView, nextButton)
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(Const.collectionTop.adjustedH)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-4)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(52)
        }
    }
}

// MARK: - CollectionView Delegate & DataSource

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCell.className, for: indexPath) as? OnboardingCell else { return UICollectionViewCell() }
        cell.setOnboardingData(model: onboardingData[indexPath.item])
        return cell
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
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

extension OnboardingViewController {
    
    enum Const {
        static let nextButtonAttributes = Typography.Attributes(
            style: .body,
            weight: .medium,
            textColor: .winey_gray0
        )
        
        static let collectionTop: CGFloat = 45
    }
}
