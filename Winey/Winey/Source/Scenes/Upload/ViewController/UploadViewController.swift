//
//  UploadViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/07/11.
//

import UIKit
import Combine
import PhotosUI
import Foundation

import DesignSystem
import CHIPageControl
import SnapKit

class UploadViewController: UIViewController {
    
    // MARK: - Properties
    
    private var stageIdx: Int = 0 {
        didSet {
            if stageIdx == 2 {
                nextButton.isEnabled = false
                nextButton.setTitle("업로드", for: .normal)
                pageGuide.currentPage = stageIdx
                navigationBar.leftBarItem = .back
                thirdPage.configure(true)
                secondPage.configure(false)
                activateBtn(2)
            } else if stageIdx == 1 {
                nextButton.isEnabled = true
                nextButton.setTitle("다음", for: .normal)
                pageGuide.currentPage = stageIdx
                navigationBar.leftBarItem = .back
                thirdPage.configure(false)
                secondPage.configure(true)
                activateBtn(1)
            } else {
                nextButton.setTitle("다음", for: .normal)
                pageGuide.currentPage = stageIdx
                navigationBar.leftBarItem = .close
                secondPage.configure(false)
                activateBtn(0)
            }
        }
    }
    
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

    private var pageGuideSubject = PassthroughSubject<Void, Never>()
    private var bag = Set<AnyCancellable>()
    
    private var pageGuide = UploadBaseView()
    
    private let firstPage = PhotoUploadView()
    private let secondPage = ContentsWriteView()
    private let thirdPage = PriceUploadView()
    
    private lazy var navigationBar = WINavigationBar(leftBarItem: .close)
    
    private let imagePicker = UIImagePickerController()
    
    // Upload Target Data
    private var feedImage: UIImage?
    private var feedTitle: String = "" {
        didSet {
            activateBtn(1)
        }
    }
    private var feedPrice: Int64 = 0 {
        didSet {
            activateBtn(2)
        }
    }
    
    // MARK: - UI Components
    
    private lazy var grayDot: CHIPageControlAji = {
        let dot = CHIPageControlAji()
        dot.numberOfPages = 3
        dot.radius = 5
        dot.padding = 8
        dot.currentPageTintColor = .winey_purple400
        dot.tintColor = .winey_gray200
        return dot
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = false
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .white
        return view
    }()
    
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
        setKeyboardObserver()
    }
    
    // MARK: - Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind() {
        pageGuideSubject
            .sink { [weak self] _ in
                self?.pageGuide.setUI()
            }
            .store(in: &bag)
    }
    
    @objc private func tapLeftButton() {
        if navigationBar.leftBarItem == .back {
            self.gotoFront()
        } else {
            self.viewDismiss()
        }
    }
    
    func setUI() {
        view.backgroundColor = .white
        
        otherPageBar.isHidden = true
        firstPageBar.isHidden = false
                
        // 버튼 인덱스 맞춰주기
        grayDot.progress = Double(stageIdx)
        pageGuide.currentPage = Int(grayDot.progress)
        
        imagePicker.delegate = self
        
        navigationBar.leftButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        
        
        // 버튼 인덱스 맞춰주기
        grayDot.progress = Double(stageIdx)
        pageGuide.currentPage = Int(grayDot.progress)
        
        nextButton.addTarget(self, action: #selector(gotoNext), for: .touchUpInside)
        
        firstPage.galleryBtn.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
        firstPage.photoBtn.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
        
        secondPage.textSendClousre = { data in
            self.feedTitle = data
        }
        
        thirdPage.sendPriceClosure = { data in
            self.feedPrice = data
        }
        
        nextButton.addTarget(self, action: #selector(gotoNext), for: .touchUpInside)
    }
    
    func setLayout() {
        
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
        
        view.addSubviews(navigationBar, grayDot, pageGuide, scrollView, nextButton)
    
        // 임의로 만든 네비게이션 바
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.horizontalEdges.equalToSuperview()
        }
        
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
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object:nil)
    }
    
    func activateBtn(_ step: Int) {
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
        
    @objc
    func viewDismiss() {
        self.dismiss(animated: true)
    }
    
    @objc
    func gotoNext() {
        navigationBar.leftButton.isEnabled = false
            
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x
                                            + UIScreen.main.bounds.width, y: 0), animated: true)
        
        stageIdx += 1
        grayDot.progress += 1
        pageGuideSubject.send(Void())

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.navigationBar.leftButton.isEnabled = true
        }
    }
    
    @objc
    func gotoFront() {
        navigationBar.leftButton.isEnabled = false

        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x
                                            - UIScreen.main.bounds.width, y: 0), animated: true)
        
        stageIdx -= 1
        grayDot.progress -= 1
        pageGuideSubject.send(Void())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.navigationBar.leftButton.isEnabled = true
        }
    }

    @objc
    func pickPhoto() {
        galleryAuth()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0
        )
        
        self.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.size.height)
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.nextButton.transform = .identity
        })
    }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func galleryAuth() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied:
            self.showAlertAuth("앨범")
        case .authorized:
            self.openPhotoLibrary()
        case .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization { state in
                if state == .authorized {
                    self.openPhotoLibrary()
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        default:
            break
        }
    }
    
    func showAlertAuth(_ type: String) {
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
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
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
    
    private func openPhotoLibrary() {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("image_info = \(image)")
            feedImage = image
            activateBtn(stageIdx)
            firstPage.configure(image)
        }
        dismiss(animated: true, completion: nil)
    }
}

private extension UploadViewController {
    enum Const {
        static let nextButtonAttributes = Typography.Attributes(
            style: .body,
            weight: .medium,
            textColor: .winey_gray500
        )
    }
}
