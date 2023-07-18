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
            
            if stageIdx != 0 {
                setAddTarget()
            }
        }
    }
    
    /// isOk: nextButton의 활성화여부를 가지는 변수, isOK 값이 바뀌면 그 값에 따라 버튼 활성화 조건이 바뀐다.
    private var isOk: Bool = false {
        didSet {
            if isOk {
                nextButton.isEnabled = true
                nextButton.backgroundColor = .winey_yellow
                nextButton.setTitleColor(.winey_gray900, for: .normal)
            } else {
                nextButton.isEnabled = false
                nextButton.backgroundColor = .winey_gray200
                nextButton.setTitleColor(.winey_gray500, for: .normal)
            }
        }
    }
    
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private let spacing: CGFloat = 17
    private let titles: [String] = ["다음", "저장하기", "업로드"]
    
    private var pageGuideSubject = PassthroughSubject<Void, Never>()
    private var bag = Set<AnyCancellable>()
    
    /// 업로드 단계별로 나타나는 뷰와 커스텀 네비게이션 바 객체 생성
    private let pageGuide = UploadBaseView()
    private let firstPage = PhotoUploadView()
    private let secondPage = ContentsWriteView()
    private let thirdPage = PriceUploadView()
    private let navigationBar = WINavigationBar(leftBarItem: .close)
    
    /// 갤러리에서 이미지를 선택할 수 있게 해주는 UIImagePickerController 객체
    private let imagePicker = UIImagePickerController()
    
    /// feed가 업로드될 때 필요한 데이터들
    private var feedImage: UIImage?
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
    private let nextButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .winey_gray200
        btn.isEnabled = false
        let title = Typography.build(string: "다음", attributes: Const.nextButtonAttributes)
        btn.setAttributedTitle(title, for: .normal)
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
    }
    
    /// UploadViewController.view의 UI를 설정해주는 함수
    private func setUI() {
        view.backgroundColor = .white
        
        imagePicker.delegate = self
        
        let title = Typography.build(string: titles[stageIdx], attributes: Const.nextButtonAttributes)
        
        nextButton.setAttributedTitle(title, for: .normal)
        
        pageGuide.currentPage = stageIdx
        
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
        let viewWidth: CGFloat = UIScreen.main.bounds.width - (2*spacing)
        
        for idx in 0..<3 {
            let component = subViews[idx]
            component.frame = CGRect(x: x+spacing, y: 0, width: viewWidth, height: 182)
            
            component.backgroundColor = .white
            scrollView.addSubview(component)
            
            x += view.frame.origin.x + viewWidth + (2 * spacing)
        }
        
        scrollView.contentSize = CGSize(width: x+spacing, height: 182)
    }
    
    private func setLayout() {
        setScrollView()
        
        view.addSubviews(navigationBar, grayDot, pageGuide, scrollView, nextButton)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.horizontalEdges.equalToSuperview()
        }
        
        grayDot.snp.makeConstraints {
            $0.top.equalToSuperview().inset(115)
            $0.leading.equalToSuperview().inset(17)
        }
        
        pageGuide.snp.makeConstraints {
            $0.top.equalTo(grayDot.snp.bottom).offset(17)
            $0.leading.equalToSuperview().inset(17)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(pageGuide.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(182)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).inset(4)
            $0.height.equalTo(52)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    /// setAddTarget: 업로드 단계에 따라 버튼과 네비게이션바 등에 다른 액션함수 지정
    private func setAddTarget() {
        navigationBar.leftButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        firstPage.galleryBtn.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
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
    }
    
    /// setButtonActivate
    /// 업로드 단계에 따라 버튼이 활성화 될 지 말지를 결정해주는 함수
    private func setButtonActivate(_ step: Int) {
        switch step {
        case 0:
            if feedImage != nil {
                isOk = true
            } else {
                isOk = false
            }
        case 1:
            if feedTitle.count >= 5 {
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
        if navigationBar.leftBarItem == .back {
            self.gotoFront()
        } else {
            self.dismissUploadViewController()
        }
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
        print(feedImage!)
        print(feedTitle)
        print(feedPrice)
    }
    
    // photoButton
    
    /// 갤러리 접근 함수
    @objc
    private func pickPhoto() {
        setGalleryAuth()
    }
    
    // keyboard
    
    /// 키보드 올리기/내리기에 관련된 함수
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        _ = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0
        )
        
        self.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.size.height)
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.nextButton.transform = .identity
        })
    }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// 갤러리 접근 권한 상태에 따른 함수 분기처리 
    func setGalleryAuth() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied:
            self.setAuthAlert("앨범")
        case .authorized:
            self.openGallery()
        case .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization { state in
                if state == .authorized {
                    self.openGallery()
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        default:
            break
        }
    }
    
    /// 갤러리 접근권한 허용 Alert에 관한 세팅
    func setAuthAlert(_ type: String) {
        if let appName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String {
            let alertVC = UIAlertController(
                title: "설정",
                message: "\(appName)이(가) \(type) 접근 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?",
                preferredStyle: .alert
            )
            let cancelAction = UIAlertAction(
                title: "취소",
                style: .cancel,
                handler: nil
            )
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                UIApplication.shared.open(
                    URL(
                        string: UIApplication.openSettingsURLString)!,
                    options: [:],
                    completionHandler: nil
                )
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(confirmAction)
            self.present(alertVC, animated: true, completion: nil)
        }
        
        view.addSubviews(grayDot, pageGuide, scrollView, nextButton)
        
        // PageControl
        grayDot.snp.makeConstraints {
            $0.top.equalToSuperview().inset(115)
            $0.leading.equalToSuperview().inset(17)
        }
        
        // UploadBaseView
        pageGuide.snp.makeConstraints {
            $0.top.equalTo(grayDot.snp.bottom).offset(17)
            $0.leading.equalToSuperview().inset(17)
        }
        
        // ScrollView
        scrollView.snp.makeConstraints {
            $0.top.equalTo(pageGuide.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(182)
        }
        
        // 다음 버튼
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).inset(4)
            $0.height.equalTo(52)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    /// 앨범 열기 함수
    func openGallery() {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            DispatchQueue.main.async {
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.modalPresentationStyle = .currentContext
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        } else {
            print("앨범에 접근할 수 없습니다.")
        }
    }
    
    /// 이미지 선택 시에 동작할 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("image_info = \(image)")
            feedImage = image
            setButtonActivate(stageIdx)
            firstPage.configure(image)
        }
        dismiss(animated: true, completion: nil)
    }
}

/// nextButton의 글자 폰트
private extension UploadViewController {
    enum Const {
        static let nextButtonAttributes = Typography.Attributes(
            style: .body,
            weight: .medium,
            textColor: .winey_gray500
        )
    }
}