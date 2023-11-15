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
    private let navigationBar = WINavigationBar(leftBarItem: .back)
    
    private let viewType: NicknameType
    
    private lazy var namePublisher = PassthroughSubject<(Bool, String), Never>()
    private lazy var bag = Set<AnyCancellable>()
    
    private let nicknameService = NicknameService()
    
    // 최근에 입력했던 닉네임
    private var recentNickname: String = ""
    
    // 기존 닉네임
    private var originalNickname: String = "" {
        didSet {
            nickNameTextField.setName(originalNickname)
        }
    }
    
    // 닉네임 길이
    private var nickNameLength: Int = 0 {
        didSet {
            nickNameTextField.setLabel(nickNameLength)
        }
    }
    
    // 중복 검사 결과
    private var duplicateResult: Bool = true
    
    // 중복 체크 여부
    private var duplicateChecked: Bool = false
    
    // 확인 버튼 터치 여부
    private var saveBtnTapped: Bool = false
    
    // 에러 발생 여부
    private var isError: Bool = false
    
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
        let btn = MIButton(type: .gray)
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
                self?.checkNickname(name, self?.duplicateResult ?? false)
            }
            .store(in: &bag)
        
        nickNameTextField.textFieldDidEndEditingPublisher
            .sink { [weak self] _ in
                self?.checkInactive(self?.nickNameTextField.getName() ?? "")
            }.store(in: &bag)
        
        nickNameTextField.startFixingPublisher
            .sink { [weak self] _ in
                self?.saveBtnTapped = false
                self?.detailLabel.isHidden = true
                self?.nickNameTextField.makeActiveView()
                self?.duplicateChecked = false
                self?.nextButton.setNicknameBtnActivate(true)
                self?.recentNickname = ""
                
//                if self?.nickNameTextField.getName().count == 0 {
//                    self?.nickNameTextField.makeErrorView()
//                    self?.setDuplicateResultText(.none)
//                }
            }
            .store(in: &bag)
    }
    
    // 중복 검사 결과 닉네임 & 중복 여부 값
    private func checkNickname(_ text: String, _ result: Bool) {
        if text.count > 0 {
            // 닉네임 중복
            if result {
                // 최초 텍스트필드 탭 하였을 때
                if recentNickname == "" && originalNickname == nickNameTextField.getName() {
                    nickNameTextField.makeActiveView()
                }
                // 중복 판정 받은 닉네임과 현재 텍스트필드에 적힌 닉네임이 같을경우
                else if recentNickname == nickNameTextField.getName() {
                    if !saveBtnTapped {
                        nickNameTextField.makeErrorView()
                        setDuplicateResultText(.fail)
                        detailLabel.isHidden = false
                    }
                } else {
                    // 중복 판정 받은 닉네임 != 텍스트필드에 적힌 닉네임
                    nickNameTextField.makeActiveView()
                }
            } else {
                // 닉네임 중복 x
                // 사용 가능 판정 받은 닉네임과 현재 텍스트필드에 적힌 닉네임이 같을경우
                if recentNickname == nickNameTextField.getName() {
                    nickNameTextField.makeSuccessView()
                    setDuplicateResultText(.success)
                    detailLabel.isHidden = false
                } else {
                    // 사용 가능 판정 받은 닉네임 != 텍스트필드에 적힌 닉네임
                    nickNameTextField.makeActiveView()
                }
            }
        } else {
            nickNameTextField.makeActiveView()
            // setDuplicateResultText(.none)
        }
    }
    
    private func checkInactive(_ text: String) {
        if text.count == 0 {
            nickNameTextField.makeInactiveView()
            detailLabel.isHidden = true
        } else {
            if detailLabel.isHidden == true {
                nickNameTextField.makeInactiveView()
            }
        }
    }
    
    private func setDuplicateResultText(_ result: DuplicateCheckResult) {
        detailLabel.isHidden = false
        detailLabel.textColor = result.color
        detailLabel.text = result.text
    }
    
    private func setButtonActivate(_ text: String, _ result: Bool) {
        // 중복체크완료 + 중복검사 통과 + 텍스트필드 안변했을 때
        if !result && duplicateChecked {
            nextButton.setNicknameBtnActivate(false)
        } else {
            nextButton.setNicknameBtnActivate(true)
        }
    }
    
    func configure(_ name: String) {
        originalNickname = name
        nickNameTextField.setLabel(name.count)
    }
    
    @objc
    private func tapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func tapDuplicateButton() {
        
        if nickNameTextField.getName().count == 0 {
            nickNameTextField.makeErrorView()
            setDuplicateResultText(.none)
        } else {
            // 중복체크 x -> 중복체크 o로 토글
            if !duplicateChecked { duplicateChecked.toggle() }
            
            // 중복체크 받은 닉네임 저장
            recentNickname = nickNameTextField.getName()
            
            // 중복 검사 서버통신
            nicknameService.duplicateCheck(nickname: recentNickname) { response in
                guard let response = response else { return }
                
                // 중복여부 결과 값 반영
                self.duplicateResult = response.data.isDuplicated
                self.setButtonActivate(self.recentNickname, response.data.isDuplicated)
                
                if response.data.isDuplicated {
                    self.nickNameTextField.makeErrorView()
                    self.setDuplicateResultText(.fail)
                } else {
                    self.nickNameTextField.makeSuccessView()
                    self.setDuplicateResultText(.success)
                }
            }
        }
    }
    
    @objc
    private func tapCheckButton() {
        saveBtnTapped = true
        recentNickname = nickNameTextField.getName()
        
        let logEvent = LogEventImpl(
            category: .click_button,
            parameters: [
                "button_name": "nickname_next_button",
                "page_number": 1
            ]
        )
        AmplitudeManager.logEvent(event: logEvent)
        
        if nickNameTextField.getName().count == 0 {
            nickNameTextField.makeErrorView()
            setDuplicateResultText(.none)
        } else {
            if duplicateChecked {
                if !duplicateResult {
                    
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
                } else {
                    recentNickname = nickNameTextField.getName()
                    nickNameTextField.makeErrorView()
                    setDuplicateResultText(.notChecked)
                }
            } else {
                recentNickname = nickNameTextField.getName()
                nickNameTextField.makeErrorView()
                setDuplicateResultText(.notChecked)
            }
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
        case notChecked
        case none
        
        var text: String {
            switch self {
            case .success:
                return "사용 가능한 닉네임입니다 :)"
            case .fail:
                return "중복된 닉네임입니다 :("
            case .notChecked:
                return "닉네임 중복확인을 해주세요 :("
            case .none:
                return "닉네임을 입력 해주세요 :("
            }
        }
        
        var color: UIColor {
            switch self {
            case .success:
                return .winey_blue500
            case .fail, .notChecked, .none:
                return .winey_red500
            }
        }
    }
}
