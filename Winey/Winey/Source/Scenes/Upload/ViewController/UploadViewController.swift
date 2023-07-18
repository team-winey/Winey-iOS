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
    
    private var stageIdx: Int = 0 {
        didSet {
            setUI()
            setButtonActivate(stageIdx)
            
            if stageIdx != 0 {
                setAddTarget()
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
    private let titles: [String] = ["다음", "저장하기", "업로드"]

    private var pageGuideSubject = PassthroughSubject<Void, Never>()
    private var bag = Set<AnyCancellable>()
    
    private let pageGuide = UploadBaseView()
    private let firstPage = PhotoUploadView()
    private let secondPage = ContentsWriteView()
    private let thirdPage = PriceUploadView()
    private let navigationBar = WINavigationBar(leftBarItem: .close)
    
    private let imagePicker = UIImagePickerController()
    
    private var feedImage: UIImage?
    private var feedTitle: String = "" {
        didSet {
            setButtonActivate(1)
        }
    }
    private var feedPrice: Int64 = 0 {
        didSet {
            setButtonActivate(2)
        }
    }
    
    // MARK: - UI Components
    
    private let grayDot: CHIPageControlAji = {
        let dot = CHIPageControlAji()
        dot.numberOfPages = 3
        dot.radius = 5
        dot.padding = 8
        dot.currentPageTintColor = .winey_purple400
        dot.tintColor = .winey_gray200
        return dot
    }()
    
    private let scrollView: UIScrollView = {
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
        setNotification()
        setAddTarget()
        getData()
    }
    
    // MARK: - Methods
    
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
    
    private func setUI() {
        view.backgroundColor = .white
        
        imagePicker.delegate = self
        
        let title = Typography.build(string: titles[stageIdx], attributes: Const.nextButtonAttributes)
        
        nextButton.setAttributedTitle(title, for: .normal)
        
        pageGuide.currentPage = stageIdx
        
        switch stageIdx {
        case 1, 2:
            navigationBar.leftBarItem = .back
        default:
            navigationBar.leftBarItem = .close
        }
    }
    
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
    
    private func getData() {
        secondPage.textSendClousre = { data in
            self.feedTitle = data
        }
        
        thirdPage.textContentView.uploadPrice = { data in
            self.feedPrice = data
        }
    }
    
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
    
    @objc
    private func postData() {
        print(feedImage!)
        print(feedTitle)
        print(feedPrice)
    }
    
    // photoButton

    @objc
    private func pickPhoto() {
        setGalleryAuth()
    }
    
    // keyboard
    
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

private extension UploadViewController {
    enum Const {
        static let nextButtonAttributes = Typography.Attributes(
            style: .body,
            weight: .medium,
            textColor: .winey_gray500
        )
    }
}
