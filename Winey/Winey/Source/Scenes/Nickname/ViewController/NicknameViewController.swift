//
//  NicknameViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/08/16.
//
import Combine
import UIKit

import DesignSystem
import SnapKit

class NicknameViewController: UIViewController {
    
    private let duplicateCheckBtn = DuplicateCheckButton()
    private let nickNameTextField = WITextFieldView(type: .nickName)
    private let navigationBar = WINavigationBar(leftBarItem: .close)
    
    private let viewType: NicknameType
    
    private lazy var namePublisher = PassthroughSubject<(Bool, String), Never>()
    private lazy var bag = Set<AnyCancellable>()
    
    private let nicknameService = NicknameService()
    
    private var recentNickname: String = ""
    private var originalNickname: String = "" {
        didSet {
            nickNameTextField.setName(originalNickname)
        }
    }
    
    private var duplicateResult: Bool = false
    
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
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.isHidden = true
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
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let logEvent = LogEventImpl(category: .view_set_nickname)
        AmplitudeManager.logEvent(event: logEvent)
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
        
        view.addSubviews(titleLabel, subTitle, duplicateCheckBtn, nickNameTextField, detailLabel, nextButton)
        
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
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp.bottom).offset(42)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(112)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(24)
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
        detailLabel.setText("", attributes: Const.detailLabelAttributes)
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
        duplicateCheckBtn.addTarget(self, action: #selector(tapDuplicateButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(tapCheckButton), for: .touchUpInside)
    }
    
    private func makeSuccessView() {
        nickNameTextField.makeBorder(width: 1, color: DuplicateCheckResult.success.color)
    }
    
    private func bind() {
        nickNameTextField.stringPublisher
            .sink { [weak self] name in
                self?.hideDetailLabel(name)
                self?.checkNickname(name, self?.duplicateResult ?? false)
                self?.setButtonActivate(name, self?.duplicateResult ?? false)
            }
            .store(in: &bag)
        
        nickNameTextField.textFieldDidEndEditingPublisher
            .sink { [weak self] _ in
                self?.checkInactive(self?.nickNameTextField.getName() ?? "")
                self?.setButtonActivate(self?.nickNameTextField.getName() ?? "", self?.duplicateResult ?? false)
            }.store(in: &bag)
    }
    
    private func checkNickname(_ text: String, _ result: Bool) {
        if text == recentNickname && text.count > 0 {
            if result {
                nickNameTextField.makeErrorView()
                setDuplicateResultText(.fail)
            } else {
                nickNameTextField.makeSuccessView()
                setDuplicateResultText(.success)
            }
        } else {
            nickNameTextField.makeActiveView()
            detailLabel.isHidden = true
        }
    }
    
    private func checkInactive(_ text: String) {
        text == recentNickname && text.count > 0 ? checkNickname(text, duplicateResult) : nickNameTextField.makeInactiveView()
    }
    
    private func hideDetailLabel(_ name: String) {
        if name != recentNickname { detailLabel.isHidden = true }
    }
    
    private func setDuplicateResultText(_ result: DuplicateCheckResult) {
        detailLabel.isHidden = false
        detailLabel.textColor = result.color
        detailLabel.text = result.text
    }
    
    private func setButtonActivate(_ text: String, _ result: Bool) {
        if !result && text == recentNickname && text != "" {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    
    func configureNickname(_ name: String) {
        originalNickname = name
    }
    
    @objc
    private func tapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func tapDuplicateButton() {
        recentNickname = nickNameTextField.getName()
        
        nicknameService.duplicateCheck(nickname: recentNickname) { response in
            guard let response = response else { return }
 
            self.duplicateResult = response.data.isDuplicated
            self.checkNickname(self.recentNickname, response.data.isDuplicated)
            self.setButtonActivate(self.recentNickname, response.data.isDuplicated)
        }
    }
    
    @objc
    private func tapCheckButton() {
        recentNickname = nickNameTextField.getName()
        
        let logEvent = LogEventImpl(
            category: .click_button,
            parameters: [
                "button_name": "nickname_next_button",
                "page_number": 1
            ]
        )
        AmplitudeManager.logEvent(event: logEvent)
        
        nicknameService.setNickname(nickname: recentNickname) { [self] response in
            if response {
                print("닉네임 등록 성공")
                if self.viewType.naviExist {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.switchRootViewController(rootViewController: TabBarController(), animated: true)
                }
            } else { print("닉네임 등록 실패") }
        }
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
        
        static let detailLabelAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium
        )
    }
    
    enum DuplicateCheckResult {
        case success
        case fail
        
        var text: String {
            switch self {
            case .success:
                return "사용 가능한 닉네임입니다 :)"
            case .fail:
                return "중복된 닉네임입니다 :("
            }
        }
        
        var color: UIColor {
            switch self {
            case .success:
                return .winey_blue500
            case .fail:
                return .winey_red500
            }
        }
    }
}
