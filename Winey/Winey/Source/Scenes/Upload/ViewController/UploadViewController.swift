//
//  UploadViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/07/11.
//

import Combine
import Foundation
import PhotosUI
import UIKit

import CHIPageControl
import DesignSystem
import SnapKit

class UploadViewController: UIViewController {
    
    // MARK: - Properties
    
    /// stageIdx: 업로드 단계를 가지는 변수 -> 값이 변경되면 UI가 업데이트 되면서 버튼에 부여되는 액션 함수와 활성화 조건을 다시 판별함
    private var stageIdx: Int = 0 {
        didSet {
            setUI()
            setButtonActivate(stageIdx)
            
            if stageIdx != 0 { setAddTarget() }
        }
    }
    
    /// isOk: nextButton의 활성화여부를 가지는 변수, isOK 값이 바뀌면 그 값에 따라 버튼 활성화 조건이 바뀐다.
    private var isOk: Bool = false {
        didSet { nextButton.isEnabled = isOk }
    }
    
    var postResultClousure: ((_ data: Bool) -> Void)?
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private let spacing: CGFloat = 24
    
    private var pageGuideSubject = PassthroughSubject<Void, Never>()
    private var bag = Set<AnyCancellable>()
    
    /// 업로드 단계별로 나타나는 뷰와 커스텀 네비게이션 바 객체 생성
    private let pageGuide = UploadBaseView()
    private let firstPage = PhotoUploadView()
    private let secondPage = ContentsWriteView()
    private let thirdPage = PriceUploadView()
    private let navigationBar = WINavigationBar(leftBarItem: .close)
    
    /// feed가 업로드될 때 필요한 데이터들
    private var feedImage: UIImage = UIImage()
    private var feedTitle: String = "" {
        didSet {
            setButtonActivate(1)
        }
    }
    private var feedPrice: Int = 0 {
        didSet {
            setButtonActivate(2)
        }
    }
    
    private var textExist: Bool = false
    
    private let postService = FeedService()
            
    // MARK: - UI Components
    
    /// grayDot: 업로드 단계를 알려주는 커스텀 PageControl
    private let grayDot: CHIPageControlAji = {
        let dot = CHIPageControlAji()
        dot.numberOfPages = 3
        dot.radius = 5
        dot.padding = 8
        dot.currentPageTintColor = .winey_purple400
        dot.tintColor = .winey_gray200
        return dot
    }()
    
    /// scrollView: 업로드 단계들을 위한 뷰를 담은 scrollView
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .white
        return view
    }()
    
    /// nextButton: 다음 단계로 이동하는 하단 버튼
    private let nextButton: MIButton = {
        let btn = MIButton(type: .yellow)
        btn.isEnabled = false
        btn.setTitle("다음", for: .normal)
        return btn
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bind()
        setNotification()
        setAddTarget()
        getData()
        setDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let logEvnet = LogEventImpl(category: .view_upload)
        AmplitudeManager.logEvent(event: logEvnet)
    }
    // MARK: - Methods
    
    /// touchesBegan: 화면 터치하면 firstResponder resign
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func bind() {
        pageGuideSubject
            .sink { [weak self] _ in
                self?.pageGuide.setUI()
            }
            .store(in: &bag)
        
        NotificationCenter.default.publisher(for: .whenImgSelected)
            .compactMap({ $0.userInfo?["img"] as? UIImage })
            .sink(receiveValue: { [weak self] img in
                self?.afterImageSelected(img)
            })
            .store(in: &bag)
    }
    
    /// UploadViewController.view의 UI를 설정해주는 함수
    private func setUI() {
        view.backgroundColor = .white
        
        pageGuide.currentPage = stageIdx
                
        nextButton.setTitle(stageIdx == 2 ? "업로드" : "다음", for: .normal)
        
        /// 업로드 뷰 단계에 따라서 네비게이션바 좌측 버튼에 다른 이미지가 들어가도록 함
        switch stageIdx {
        case 1, 2:
            navigationBar.leftBarItem = .back
        default:
            navigationBar.leftBarItem = .close
        }
    }
    
    /// setScrollView: 스크롤 뷰에 페이지 뷰 객체 저장
    private func setScrollView() {
        let subViews = [firstPage, secondPage, thirdPage]
        
        var x: CGFloat = 0
        let viewWidth: CGFloat = UIScreen.main.bounds.width - (2 * spacing)
        
        for idx in 0..<3 {
            let component = subViews[idx]
            component.frame = CGRect(x: x + spacing, y: 0, width: viewWidth, height: 256)
            
            component.backgroundColor = .white
            scrollView.addSubview(component)
            
            x += view.frame.origin.x + viewWidth + (2 * spacing)
        }
        
        scrollView.contentSize = CGSize(width: x + spacing, height: 256)
    }
    
    private func setLayout() {
        setScrollView()
        
        view.addSubviews(navigationBar, grayDot, pageGuide, scrollView, nextButton)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.horizontalEdges.equalToSuperview()
        }
        
        grayDot.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(24)
        }
        
        pageGuide.snp.makeConstraints {
            $0.top.equalTo(grayDot.snp.bottom).offset(27)
            $0.leading.equalToSuperview().inset(24)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(pageGuide.snp.bottom).offset(42)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(256)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).inset(4)
            $0.height.equalTo(52)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    /// setAddTarget: 업로드 단계에 따라 버튼과 네비게이션바 등에 다른 액션함수 지정
    private func setAddTarget() {
        navigationBar.leftButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        firstPage.photoBtn.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
        
        if stageIdx == 2 {
            nextButton.removeTarget(self, action: #selector(gotoNext), for: .touchUpInside)
            nextButton.addTarget(self, action: #selector(postData), for: .touchUpInside)
        } else {
            nextButton.removeTarget(self, action: #selector(postData), for: .touchUpInside)
            nextButton.addTarget(self, action: #selector(gotoNext), for: .touchUpInside)
        }
    }
    
    /// setFirstResponder: 업로드 단계에 따라 responder를 어디다가 지정할지 결정하는 함수
    private func setFirstResponder() {
        switch stageIdx {
        case 1:
            secondPage.configure(true)
        case 2:
            thirdPage.configure(true)
            secondPage.configure(false)
        default:
            secondPage.configure(false)
        }
    }
    
    private func afterImageSelected(_ img: UIImage) {
        self.firstPage.photoBtn.setImage(img, for: .normal)
        self.feedImage = img
        self.setButtonActivate(self.stageIdx)
        self.firstPage.configure(img)
    }
    
    /// getData
    /// 1. secondPage 객체로부터 절약 내용 데이터를 전달 받음
    /// 2. thridPage 객체로부터 절약 금액 데이터를 전달 받음
    private func getData() {
        secondPage.textSendClousre = { data in
            self.feedTitle = data
        }
        
        thirdPage.textContentView.uploadPrice = { data in
            self.feedPrice = data
        }
    }
    
    /// setNotification
    /// 키보드가 올라오고 내려오고 하는 동작에 관련된 Notification 관찰자 지정
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object:nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func textValidation(text: String) -> Bool {
        let pureText = text.trimmingCharacters(in: .whitespaces)
        return pureText.count > 0
    }
    
    private func setDelegate() {
        PhotoManager.shared.photoDelegate = self
    }
    
    /// setButtonActivate
    /// 업로드 단계에 따라 버튼이 활성화 될 지 말지를 결정해주는 함수
    private func setButtonActivate(_ step: Int) {
        switch step {
        case 0:
            if feedImage != UIImage() {
                isOk = true
            } else {
                isOk = false
            }
        case 1:
            if feedTitle.count >= 5 && textValidation(text: feedTitle) {
                isOk = true
            } else {
                isOk = false
            }
        default:
            if feedPrice != 0 {
                isOk = true
            } else {
                isOk = false
            }
        }
    }
    
    // NavigationBar
    /// NavigationBar 상의 버튼을 클릭했을때의 동작을 정의하는 함수
    
    @objc
    private func tapLeftButton() {
        if stageIdx == 0 && isOk {
            let vc = MIPopupViewController(content: .init(
                title: "지금 나가시면 작성하신 게 지워져요",
                subtitle: "절약 실천 게시물을 올리시면 레벨업에 가까워져요\n그래도 나가시겠습니까?")
            )
            
            vc.addButton(title: "취소", type: .gray) {
                vc.dismiss(animated: true)
            }
            
            vc.addButton(title: "나가기", type: .yellow) {
                self.setNaviBtn(self.navigationBar.leftBarItem)
            }
            
            self.present(vc, animated: true)
        } else {
            setNaviBtn(self.navigationBar.leftBarItem)
        }
    }
    
    private func setNaviBtn(_ type: WINavigationBar.BarItem?) {
        type == .back ? self.gotoFront() : self.dismissUploadViewController()
    }
    
    @objc
    private func dismissUploadViewController() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func gotoFront() {
        navigationBar.leftButton.isEnabled = false
        
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x
                                            - UIScreen.main.bounds.width, y: 0), animated: true)
        stageIdx -= 1
        grayDot.progress -= 1
        grayDot.progress = Double(stageIdx)
        pageGuide.currentPage = Int(grayDot.progress)
        
        pageGuideSubject.send(Void())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.navigationBar.leftButton.isEnabled = true
        }
        
        setFirstResponder()
    }
    
    // nextButton
    /// nextButton 눌렀을 때의 동작을 정의하는 함수들
    @objc
    private func gotoNext() {
        let logEvent = LogEventImpl(
            category: .click_button,
            parameters: [
                "button_name": "upload_next_button",
                "page_number": stageIdx + 1
            ]
        )
        AmplitudeManager.logEvent(event: logEvent)
        navigationBar.leftButton.isEnabled = false
        
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x
                                            + UIScreen.main.bounds.width, y: 0), animated: true)
        
        stageIdx += 1
        grayDot.progress += 1
        
        grayDot.progress = Double(stageIdx)
        pageGuide.currentPage = Int(grayDot.progress)
        
        pageGuideSubject.send(Void())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.navigationBar.leftButton.isEnabled = true
        }
        
        setFirstResponder()
    }
    
    /// 피드 업로드 함수
    @objc
    private func postData() {
        let logEvent = LogEventImpl(
            category: .click_button,
            parameters: [
                "button_name": "upload_next_button",
                "page_number": stageIdx + 1
            ]
        )
        AmplitudeManager.logEvent(event: logEvent)
        let feed = UploadModel(feedTitle, feedPrice)
        postFeed(feed: feed)
    }
    
    // photoButton
    
    /// 갤러리 접근 함수
    @objc
    private func pickPhoto() {
        PhotoManager.shared.setGalleryAuth()
    }
    
    // keyboard
    
    /// 키보드 올리기/내리기에 관련된 함수
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        var bottomInset: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            bottomInset = view.safeAreaInsets.bottom
        }
        
        let adjustedBottomSpace = keyboardFrame.size.height - bottomInset + 12
        self.nextButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
                .inset(adjustedBottomSpace)
        }
        view.layoutIfNeeded()
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        self.nextButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        view.layoutIfNeeded()
    }
}

extension UploadViewController: PhotoManaging {
    func pickImage() {
        guard let targetImg = PhotoManager.shared.selectedImage else { return }
        afterImageSelected(targetImg)
        PhotoManager.shared.clearPreselectedAssets()
    }
    
    func deniedAlert() {
        self.present(PhotoManager.shared.alertController, animated: true)
    }
    
    func openTotalGallery() {
        let vc = PhotoManager.shared.photoPicker
        
        self.present(vc, animated: true)
        vc.modalPresentationStyle = .overFullScreen
    }
    
    func openLimitedGallery() {
        let vc = GalleryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UploadViewController {
    private func postFeed(feed: UploadModel) {
        let productPolicy = ProductPolicy.productBy(feed.feedMoney)
        let loadingViewController = UploadLoadingViewController(keyword: productPolicy.rawValue)
                
        postService.feedPost(feedImage.jpegData(compressionQuality: 0.2)!, feed) { result in
            NotificationCenter.default.post(name: .whenFeedUploaded, object: nil)
            loadingViewController.feedUploadResult = result
        }
        self.navigationController?.pushViewController(loadingViewController, animated: true)
    }
}
