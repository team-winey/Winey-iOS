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
    private let loginService = LoginService()
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let logEvent = LogEventImpl(category: .view_mypage)
        AmplitudeManager.logEvent(event: logEvent)
    }
    // MARK: - UIComponents
    
    private func setUI() {
        navigationBar.hideBottomSeperatorView = false
        collectionView.backgroundColor = bottomBackgroundColor
        collectionView.register(
            MypageProfileCell.self,
            forCellWithReuseIdentifier: MypageProfileCell.className
        )
        collectionView.register(
            MypageGoalInfoCell.self,
            forCellWithReuseIdentifier: MypageGoalInfoCell.className
        )
        collectionView.register(
            MenuCell.self,
            forCellWithReuseIdentifier: MenuCell.className
        )
        collectionView.register(MypageCollectionViewFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MypageCollectionViewFooter.className)
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
        if indexPath.section == 2 && indexPath.item == 0 { // 마이피드
            let logEvent = LogEventImpl(category: .click_myfeed)
            AmplitudeManager.logEvent(event: logEvent)
            let myFeedViewController = MyFeedViewController()
            self.navigationController?.pushViewController(myFeedViewController, animated: true)
        } else if indexPath.section == 2 && indexPath.item == 1 { //1:1문의
            let url = URL(string: "https://open.kakao.com/o/s751Susf")!
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true)
        } else if indexPath.section == 2 && indexPath.item == 2 {
            let url = URL(string: "https://empty-weaver-a9f.notion.site/62b37962c661488ba5f60958c24753e1?pvs=4")!
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true)
        } else if indexPath.section == 2 && indexPath.item == 3 {
            let alert = makeLogoutAlert()
            self.present(alert, animated: true)
        }
    }
}

extension MypageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int {
        switch section {
        case 0, 1:
            return 1
        case 2:
            return 4
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        switch indexPath.section {
        case 0 :
            guard let mypageProfileCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MypageProfileCell.className,
                for: indexPath
            )  as? MypageProfileCell
            else { return UICollectionViewCell()}
            let nickname = nickname ?? ""
            let userLevel = userLevel ?? .none
            mypageProfileCell.configure(model: .init(nickname: nickname, level: userLevel))
            mypageProfileCell.infoButtonTappedClosure = {
                let logEvent = LogEventImpl(category: .click_info)
                AmplitudeManager.logEvent(event: logEvent)
                
                let guideViewController = GuideViewController()
                guideViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(guideViewController, animated: true)
            }
            mypageProfileCell.nextButtonTappedClosure = {
                let logEvent = LogEventImpl(category: .click_edit_nickname)
                AmplitudeManager.logEvent(event: logEvent)
                
                let nicknameViewController = NicknameViewController(viewType: .myPage)
                nicknameViewController.hidesBottomBarWhenPushed = true
                nicknameViewController.configureNickname(nickname)
                self.navigationController?.pushViewController(nicknameViewController, animated: true)
            }
            return mypageProfileCell
            
        case 1 :
            guard let mypageGoalInfoCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MypageGoalInfoCell.className,
                for: indexPath
            ) as? MypageGoalInfoCell
            else { return UICollectionViewCell()}
            
            if isOver {
                duringGoalCount = nil
                duringGoalAmount = nil
            }
            mypageGoalInfoCell.configure(
                model: .init(
                    duringGoalAmount,
                    duringGoalCount,
                    targetMoney,
                    dday
                )
            )
            mypageGoalInfoCell.saveGoalButtonTappedClosure = { [weak self] in
                let logEvent = LogEventImpl(category: .click_goalsetting)
                AmplitudeManager.logEvent(event: logEvent)
                
                let saveGoalVC = SaveGoalViewController()
                saveGoalVC.modalPresentationStyle = .pageSheet
                self?.present(saveGoalVC, animated: true, completion: nil)
            }
            mypageGoalInfoCell.blockAlertTappedClosure = { [weak self] in
                let blockAlert = MIPopupViewController(content: .init(title: "절약 목표 기간이 지나지 않아\n목표를 수정할 수 없어요"))
                blockAlert.addButton(title: "닫기", type: .gray, tapButtonHandler: nil)
                self?.present(blockAlert, animated: true)
            }
            
            return mypageGoalInfoCell
            
        case 2 :
            guard let menuCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MenuCell.className,
                for: indexPath
            ) as? MenuCell
            else { return UICollectionViewCell()}
            switch indexPath.item {
            case 0:
                menuCell.configureCell(.myfeed)
                menuCell.titleLabel.setText("마이피드", attributes: .init(style: .body, weight: .medium, textColor: .winey_gray700), customAttributes: nil)
            case 1:
                menuCell.configureCell(.inquiry)
                menuCell.titleLabel.setText("1:1문의", attributes: .init(style: .body, weight: .medium, textColor: .winey_gray700), customAttributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            case 2:
                menuCell.configureCell(.serviceRule)
                menuCell.titleLabel.setText("이용약관", attributes: .init(style: .body, weight: .medium, textColor: .winey_gray700), customAttributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            case 3:
                menuCell.configureCell(.logout)
                menuCell.titleLabel.setText("로그아웃", attributes: .init(style: .body, weight: .medium, textColor: .winey_gray700), customAttributes: nil)
            default:
                return UICollectionViewCell()
            }
            return menuCell

        default :
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            viewForSupplementaryElementOfKind kind: String,
                            at indexPath: IndexPath) -> UICollectionReusableView {
            guard let mypageCollectionViewFooter = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: MypageCollectionViewFooter.className,
                for: indexPath) as? MypageCollectionViewFooter else {return UICollectionReusableView()}
            mypageCollectionViewFooter.delegate = self
            return mypageCollectionViewFooter
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
        case 0: return CGSize(width: (UIScreen.main.bounds.width), height: 345)
        case 1: return CGSize(width: (UIScreen.main.bounds.width), height: 177)
        case 2: return CGSize(width: (UIScreen.main.bounds.width), height: 57)
        default : return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int)
        -> CGSize {
            switch section {
            case 0: return .zero
            case 1: return .zero
            case 2: return CGSize(width: (UIScreen.main.bounds.width), height: 113)
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
        case 0: return .init(top: 0, left: 0, bottom: 0, right: 0)
        case 1: return .init(top: 0, left: 0, bottom: 0, right: 0)
        case 2: return .init(top: 0, left: 0, bottom: 0, right: 0)
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
            self.isOver = data.userResponseGoalDto?.isOver ?? false
            
            let hasGoal = data.userResponseGoalDto != nil
            UserSingleton.saveGoal(hasGoal)
            
            self.collectionView.reloadData()
        }
    }
    
    private func judgeUserLevel(_ userLevel: String) -> UserLevel? {
        return UserLevel(rawValue: userLevel)
    }
}

// MARK: - Login
extension MypageViewController {
    
    private func makeWithdrawAlert() -> MIPopupViewController {
        let vc = MIPopupViewController(
            content: .init(title: MypageAlert.withDraw.title,
                           subtitle: MypageAlert.withDraw.subTitle)
        )
        
        vc.addButton(title: MypageAlert.withDraw.leftBtnText, type: .gray) {
            let token = KeychainManager.shared.read("accessToken")!
            DispatchQueue.global(qos: .utility).async {
                self.withdrawApple(token: token)
            }
        }
        
        vc.addButton(title: MypageAlert.withDraw.rightBtnText, type: .yellow) {
            self.dismiss(animated: true)
        }
        return vc
    }
    
    private func makeLogoutAlert() -> MIPopupViewController {
        let vc = MIPopupViewController(
            content: .init(title: MypageAlert.logOut.title,
                           subtitle: MypageAlert.logOut.subTitle)
        )
        
        vc.addButton(title: MypageAlert.logOut.leftBtnText, type: .gray) {
            self.dismiss(animated: true)
        }
        
        vc.addButton(title: MypageAlert.logOut.rightBtnText, type: .yellow) {
            let token = KeychainManager.shared.read("accessToken")!
            DispatchQueue.global(qos: .utility).async {
                let logEvent = LogEventImpl(category: .click_logout)
                AmplitudeManager.logEvent(event: logEvent)
                self.logoutWithApple(token: token)
            }
        }
        return vc
    }
    
    private func withdrawApple(token: String) {
        loginService.withdrawApple(token: token) { result in
            if result {
                KeychainManager.shared.delete("accessToken")
                KeychainManager.shared.delete("refreshToken")
                
                UserDefaults.standard.set(false, forKey: "Signed")
                
                DispatchQueue.main.async {
                    let vc = LoginViewController()
                    self.switchRootViewController(rootViewController: vc, animated: true)
                }
            } else {
                print("회원탈퇴 실패")
            }
        }
    }
    
    private func logoutWithApple(token: String) {
        loginService.logoutWithApple(token: token) { result in
            if result {
                KeychainManager.shared.delete("accessToken")
                KeychainManager.shared.delete("refreshToken")
                
                UserDefaults.standard.set(false, forKey: "Signed")
                
                DispatchQueue.main.async {
                    let vc = LoginViewController()
                    self.switchRootViewController(rootViewController: vc, animated: true)
                }
            } else {
                print("로그아웃 실패")
            }
        }
    }
}

extension MypageViewController: withDrawAccountDelegate {
    func withDrawButtonTapped() {
        let alert = makeWithdrawAlert()
        self.present(alert, animated: true)
    }
}
