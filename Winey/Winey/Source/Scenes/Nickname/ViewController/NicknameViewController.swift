//
//  NicknameViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/08/16.
//

import UIKit

import DesignSystem
import SnapKit

class NicknameViewController: UIViewController {
    
    private let duplicateCheckBtn = DuplicateCheckButton()
    private let nickNameTextField = WITextFieldView(type: .nickName)
    private let navigationBar = WINavigationBar(leftBarItem: .close)
    
    private let viewType: NicknameType
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let nextButton: MIButton = {
        let btn = MIButton(type: .yellow)
        btn.isEnabled = false
        btn.setTitle("확인", for: .normal)
        return btn
    }()
    
    // MARK: - Init func
    
    public init(viewType: NicknameType) {
        self.viewType = viewType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setGuideText()
        setNotification()
        setAddTarget()
    }
    
    // MARK: - methods
    
    private func setUI() {
        view.backgroundColor = .winey_gray0
    }
    
    private func setLayout() {
        
        if viewType.naviExist {
            view.addSubview(navigationBar)
            
            navigationBar.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide)
                $0.horizontalEdges.equalToSuperview()
            }
        }
        
        view.addSubviews(titleLabel, subTitle, duplicateCheckBtn, nickNameTextField, nextButton)
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(70)
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        duplicateCheckBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.leading.equalTo(nickNameTextField.snp.trailing).offset(8)
            $0.top.equalTo(subTitle.snp.bottom).offset(42)
            $0.height.equalTo(56)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp.bottom).offset(42)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(56)
            $0.trailing.equalToSuperview().inset(112)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(4)
            $0.height.equalTo(52)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    private func setGuideText() {
        titleLabel.setText(viewType.titleLabel, attributes: Const.titleAttributes)
        subTitle.setText("공백 또는 특수문자는 사용할 수 없습니다",
                         attributes: Const.subTitleAttributes)
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setAddTarget() {
        if viewType.naviExist {
            navigationBar.leftButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        }
    }
    
    @objc
    private func tapLeftButton() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        var bottomInset: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            bottomInset = view.safeAreaInsets.bottom
        }
        
        let adjustedBottomSpace = keyboardFrame.size.height - bottomInset + 14
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

private extension NicknameViewController {
    enum Const {
        static let titleAttributes = Typography.Attributes(
            style: .headLine2,
            weight: .bold,
            textColor: .winey_gray900
        )
        
        static let subTitleAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray400
        )
    }
}
