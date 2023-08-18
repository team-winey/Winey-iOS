//
//  SaveGoalViewController.swift
//  Winey
//
//  Created by 김인영 on 2023/07/20.
//

import Combine
import UIKit

import SnapKit
import DesignSystem

final class SaveGoalViewController: UIViewController {
    
    private let goalService = GoalService()
    private var bag = Set<AnyCancellable>()
    
    private var money: Int = 0
    private var period: Int = 0
    
    private let scrollView = UIScrollView()
    private lazy var cancelButton = UIButton()
    private let moneyTitleLabel = UILabel()

    private let moneyTextField = WITextFieldView(type: .upload_price)
    private let moneyDetailLabel = UILabel()
    
    private let periodTitleLabel = UILabel()
    private let periodTextField = WITextFieldView(type: .day)
    private let periodDetailLabel = UILabel()

    private let saveContainerView = UIView()
    private let saveLabel = UILabel()
    private let saveButton = MIButton(type: .yellow)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        bind()
        addKeyboardObserver()
    }
}

// MARK: - TextField

extension SaveGoalViewController {
    
    private func checkMoneyValue(value: Int) {
        if value < 30000 {
            // red
            self.moneyTextField.makeErrorView()
            self.moneyDetailLabel.textColor = .winey_red500
        } else {
            // purple
            self.moneyTextField.makeActiveView()
            self.moneyDetailLabel.textColor = .winey_gray400
        }
    }
    
    private func checkPeriodValue(value: Int) {
        if value < 5 || value > 365 {
            // red
            self.periodTextField.makeErrorView()
            self.periodDetailLabel.textColor = .winey_red500
        } else {
            // purple
            self.periodTextField.makeActiveView()
            self.periodDetailLabel.textColor = .winey_gray400
        }
    }
    
    private func checkSaveButtonEnabled() {
        if money >= 30000 && period >= 5 && period <= 365  {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - @objc

extension SaveGoalViewController {
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo, let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        var bottomInset: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            bottomInset = view.safeAreaInsets.bottom
        }
        
        let adjustedBottomSpace = keyboardFrame.size.height - bottomInset + 14
        self.saveContainerView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(adjustedBottomSpace)
        }
        view.layoutIfNeeded()
    }
        
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        self.saveContainerView.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(14)
        }
        view.layoutIfNeeded()
    }
    
    @objc
    private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func saveButtonTapped() {
        self.postGoal(request: PostGoalRequest(targetMoney: self.money, targetDay: self.period))
    }
}

// MARK: - UI & Layout

extension SaveGoalViewController {
    private func setUI() {
        moneyTitleLabel.setText(Const.moneyTitle, attributes: Const.titleAttributes)
        moneyDetailLabel.setText(Const.moneyDetail, attributes: Const.detailAttributes)
        periodTitleLabel.setText(Const.periodTitle, attributes: Const.titleAttributes)
        periodDetailLabel.setText(Const.periodDetail, attributes: Const.detailAttributes)
        saveLabel.setText(Const.saveDetail, attributes: Const.saveLabelAttributes)
        
        scrollView.keyboardDismissMode = .onDragWithAccessory
        
        let cancelAtrributeString = Typography.build(string: "취소", attributes: Const.cancelButtonAttributes)
        cancelButton.setAttributedTitle(cancelAtrributeString, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        saveLabel.textAlignment = .center
        saveLabel.numberOfLines = 2
        
        let saveAtrributeString = Typography.build(
            string: "저장하기",
            attributes: Const.saveButtonAttributes
        )
        let disabledSaveAttributedSTring = Typography.build(
            string: "저장하기",
            attributes: Const.saveButtonDisabledAttributes
        )
        saveButton.setAttributedTitle(saveAtrributeString, for: .normal)
        saveButton.setAttributedTitle(disabledSaveAttributedSTring, for: .disabled)
        saveButton.backgroundColor = .winey_yellow
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.isEnabled = false
    }
    
    private func setLayout() {
        view.backgroundColor = .winey_gray0
        
        let moneyBoxView = UIView()
        let periodBoxView = UIView()
        
        view.addSubviews(scrollView, saveContainerView)
        scrollView.addSubviews(cancelButton, moneyBoxView, periodBoxView)
        moneyBoxView.addSubviews(moneyTitleLabel, moneyTextField, moneyDetailLabel)
        periodBoxView.addSubviews(periodTitleLabel, periodTextField, periodDetailLabel)
        saveContainerView.addSubviews(saveLabel, saveButton)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(3)
            $0.leading.equalToSuperview().inset(9)
            $0.width.equalTo(50)
            $0.height.equalTo(45)
        }
        
        moneyBoxView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Const.boxTop.adjustedH)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(113)
        }
        
        periodBoxView.snp.makeConstraints {
            $0.top.equalTo(moneyBoxView.snp.bottom).offset(Const.boxSpace.adjustedH)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(113)
            $0.bottom.equalToSuperview()
        }
        
        moneyTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        moneyTextField.snp.makeConstraints {
            $0.top.equalTo(moneyTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        moneyDetailLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
        }
        
        periodTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        periodTextField.snp.makeConstraints {
            $0.top.equalTo(periodTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        periodDetailLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
        }
        
        saveContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(14)
            $0.height.equalTo(94)
        }
        
        saveLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(saveLabel.snp.bottom).offset(Const.buttonSpace.adjustedH)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
    
    private func bind() {
        moneyTextField.pricePublisher
            .sink { [weak self] price in
                self?.checkMoneyValue(value: price)
                self?.money = price
                self?.checkSaveButtonEnabled()
            }
            .store(in: &bag)
        
        periodTextField.pricePublisher
            .sink { [weak self] price in
                self?.checkPeriodValue(value: price)
                self?.period = price
                self?.checkSaveButtonEnabled()
            }
            .store(in: &bag)
        
        moneyTextField.textFieldDidEndEditingPublisher
            .sink { [weak self] in
                self?.moneyTextField.makeInactiveView()
                self?.moneyDetailLabel.textColor = .winey_gray400
            }
            .store(in: &bag)
        
        periodTextField.textFieldDidEndEditingPublisher
            .sink { [weak self] in
                self?.periodTextField.makeInactiveView()
                self?.periodDetailLabel.textColor = .winey_gray400
            }
            .store(in: &bag)
    }
}

private extension SaveGoalViewController {
    
    enum Const {
        static let boxTop: CGFloat = 66
        static let boxSpace: CGFloat = 34
        static let buttonSpace: CGFloat = 10
        
        static let moneyTitle = "목표 절약 금액을 설정해주세요"
        static let periodTitle = "목표 절약 일수를 설정해주세요"
        static let moneyDetail = "절약 금액을 3만원 이상으로 설정해주세요"
        static let periodDetail = "절약 일수를 5일 이상으로 설정해주세요"
        static let saveDetail = "설정한 목표는 목표 절약 일수 전까지 변경이 불가능합니다.\n신중하게 작성해주세요! "
        
        static let titleAttributes = Typography.Attributes(style: .headLine3, weight: .bold)
        static let detailAttributes = Typography.Attributes(
            style: .detail,
            weight: .medium,
            textColor: .winey_gray400
        )
        static let cancelButtonAttributes = Typography.Attributes(
            style: .body,
            weight: .medium,
            textColor: .winey_gray400
        )
        static let saveLabelAttributes = Typography.Attributes(
            style: .detail2,
            weight: .medium,
            textColor: .winey_gray400
        )
        static let saveButtonAttributes = Typography.Attributes(
            style: .body,
            weight: .medium,
            textColor: .winey_gray900
        )
        static let saveButtonDisabledAttributes = Typography.Attributes(
            style: .body,
            weight: .medium,
            textColor: .winey_gray500
        )
    }
}

//MARK: - Network

extension SaveGoalViewController {
    private func postGoal(request: PostGoalRequest) {
        goalService.postGoal(request: request) { [weak self] response in
            guard let self = self else { return }
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: .whenSetGoalCompleted, object: nil)
            }
        }
    }
}
