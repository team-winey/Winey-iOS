//
//  MypageViewController.swift
//  Winey
//
//  Created by 고영민 on 2023/07/12.
//

import SafariServices
import Combine
import UIKit

import SnapKit
import Moya
import DesignSystem
import WebKit

final class MypageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    private var nickname: String?
    private var userLevel: UserLevel?
    private var duringGoalAmount: Int?
    private var duringGoalCount: Int?
    private var targetMoney: Int?
    private var dday: Int?
    private var isOver: Bool = false
    private let userService = UserService()
    let inquiryCollectionViewCell = InquiryCollectionViewCell()
    
    // MARK: - UIComponents
    
    private let navigationBar = WINavigationBar.init(title: "마이페이지")
    private lazy var safearea = self.view.safeAreaLayoutGuide
    private let topBackgroundColor = UIColor.winey_gray0
    private let bottomBackgroundColor = UIColor.winey_gray50
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private var bag = Set<AnyCancellable>()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTotalUser()
        setupWebView()
    }
    
    // MARK: - UIComponents
    
    private func setUI() {
        navigationBar.hideBottomSeperatorView = false
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
        
        view.backgroundColor = .white
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
    
    private func bind() {
        NotificationCenter.default.publisher(for: .whenSetGoalCompleted)
            .sink { [weak self] _ in
                self?.getTotalUser()
            }
            .store(in: &bag)
    }
}

extension MypageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 { // 마이피드
            let myFeedViewController = MyFeedViewController()
            myFeedViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(myFeedViewController, animated: true)
        } else if indexPath.section == 3 {
            let url = URL(string: "https://open.kakao.com/o/s751Susf")!
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true)
        }
    }
}

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
        switch indexPath.section {
        case 0 :
            guard let mypageProfileCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MypageProfileCell.identifier,
                for: indexPath
            )  as? MypageProfileCell
            else { return UICollectionViewCell()}
            let nickname = nickname ?? ""
            let userLevel = userLevel ?? .none
            mypageProfileCell.configure(model: .init(nickname: nickname, level: userLevel))
            mypageProfileCell.infoButtonTappedClosure = {
                let guideViewController = GuideViewController()
                guideViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(guideViewController, animated: true)
            }
            return mypageProfileCell
            
        case 1 :
            guard let mypageGoalInfoCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MypageGoalInfoCell.identifier,
                for: indexPath
            ) as? MypageGoalInfoCell
            else { return UICollectionViewCell()}
            mypageGoalInfoCell.configure(
                model: .init(
                    duringGoalAmount,
                    duringGoalCount,
                    targetMoney,
                    dday
                )
            )
            mypageGoalInfoCell.saveGoalButtonTappedClosure = { [weak self] in
                let saveGoalVC = SaveGoalViewController()
                saveGoalVC.modalPresentationStyle = .pageSheet
                self?.present(saveGoalVC, animated: true, completion: nil)
            }
            return mypageGoalInfoCell
            
        case 2 :
            guard let myfeedCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyfeedCollectionViewCell.identifier,
                for: indexPath
            ) as? MyfeedCollectionViewCell
            else { return UICollectionViewCell()}
            myfeedCollectionViewCell.myfeedButtonTappedClosure = {
                let myfeedViewController = MyFeedViewController()
                myfeedViewController.viewDidLoad()
                self.navigationController?
                    .pushViewController(myfeedViewController, animated: true)
            }
            return myfeedCollectionViewCell
            
        case 3 :
            guard let inquiryCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: InquiryCollectionViewCell.identifier,
                for: indexPath
            ) as? InquiryCollectionViewCell
            else { return UICollectionViewCell()}
            inquiryCollectionViewCell.delegate = self
            return inquiryCollectionViewCell
            
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



extension MypageViewController: WKNavigationDelegate, InquiryCollectionViewCellDelegate {
    private func setupWebView() {
        let webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self // 웹뷰의 네비게이션 이벤트를 처리할 delegate 설정
        webView.isHidden = true // 일단 숨겨둡니다.
        self.view.addSubview(webView)
    }
    
    func buttonDidTapped() {
        print("___________ 델리게이트 체크 ____________")
        setupWebView()
    }

    @objc private func myfeedButtonTapped() {
        // 버튼을 클릭했을 때 호출될 메소드
        // 웹뷰를 보여주고 웹페이지를 로드합니다.
        if let url = URL(string: "https://www.naver.com") {
            if let webView = view.subviews.first(where: { $0 is WKWebView }) as? WKWebView {
                webView.isHidden = false
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
}

// MARK: - Server

extension MypageViewController {
    private func getTotalUser() {
        userService.getTotalUser() { [weak self] response in
            guard let response = response, let data = response.data else { return }
            guard let self else { return }
            let userData = data.userResponseUserDto
            self.userLevel = self.judgeUserLevel(userData.userLevel)
            self.nickname = userData.nickname
            
            let goal = data.userResponseGoalDto
            self.duringGoalCount = goal?.duringGoalCount
            self.duringGoalAmount = goal?.duringGoalAmount
            self.dday = goal?.dday
            self.targetMoney = goal?.targetMoney
            self.isOver = isOver
            
            print(userData.nickname, userData.userLevel, userData.userID)
            
            let goalData = data.userResponseGoalDto
            self.dday = goalData.dday
            self.targetMoney = goalData.targetMoney
            self.duringGoalAmount = goalData.duringGoalAmount
            self.duringGoalCount = goalData.duringGoalCount
            
            self.collectionView.reloadData()
        }
    }
    
    private func judgeUserLevel(_ userLevel: String) -> UserLevel? {
        return UserLevel(rawValue: userLevel)
    }
}

