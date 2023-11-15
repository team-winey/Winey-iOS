//
//  FloatingCommentView.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/09.
//

import Combine
import UIKit

import DesignSystem
import SnapKit

final class FloatingCommentView: UIView {
    private let textViewContainerView = UIView()
    private let textView = FloatingCommentTextView()
    private let sendButton = UIButton(type: .system)
    private let limitLabel = UILabel()
    
    private let placeholderSubject = PassthroughSubject<String, Never>()
    var placeholderPublisher: AnyPublisher<String, Never> {
        placeholderSubject.eraseToAnyPublisher()
    }
    
    private let commentSubject = PassthroughSubject<String, Never>()
    var commentPublisher: AnyPublisher<String, Never> {
        commentSubject.eraseToAnyPublisher()
    }
    
    private let didTapSendButtonSubject = PassthroughSubject<String, Never>()
    var didTapSendButtonPublisher: AnyPublisher<String, Never> {
        didTapSendButtonSubject.eraseToAnyPublisher()
    }
    
    private var comment: String?
    
    private var bag = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAttribute()
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateBottomInset(isKeyboardShown: Bool) {
        let inset = isKeyboardShown
        ? Const.bottomInset
        : Const.bottomInset + DeviceInfo.safeAreaBottomHeight
        textViewContainerView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(inset)
        }
        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    @objc private func didTapSendButton() {
        guard let comment else { return }
        didTapSendButtonSubject.send(comment)
        textView.handleAfterSendComment()
        textView.resignFirstResponder()
    }

    @objc private func didTapTextView() {
        textView.becomeFirstResponder()
    }
}

extension FloatingCommentView {
    private func setupAttribute() {
        backgroundColor = .winey_gray100
        textViewContainerView.backgroundColor = .winey_gray0
        textViewContainerView.makeCornerRound(radius: 10)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView))
        textViewContainerView.isUserInteractionEnabled = true
        textViewContainerView.addGestureRecognizer(tapGesture)
        sendButton.setTitle("등록", for: .normal)
        sendButton.setTitleColor(.winey_purple400, for: .normal)
        sendButton.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        limitLabel.textColor = .red
        textView.placeholderText = "댓글을 입력하세요"
    }
    
    private func setupLayout() {
        addSubview(textViewContainerView)
        textViewContainerView.addSubview(textView)
        textViewContainerView.addSubview(sendButton)
        textViewContainerView.addSubview(limitLabel)
        
        textViewContainerView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.top.equalToSuperview().inset(10)
            let bottomInset = Const.bottomInset + DeviceInfo.safeAreaBottomHeight
            make.bottom.equalToSuperview().inset(bottomInset)
        }
        textView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(16)
        }
        sendButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(textView.snp.trailing).offset(2)
            make.trailing.equalToSuperview().inset(5)
            make.width.equalTo(44)
            make.height.equalTo(42)
        }
        limitLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(14)
            make.centerX.equalTo(sendButton)
        }
    }
    
    private func bind() {
        textView.commentPublisher
            .sink { [weak self] comment in
                guard let self else { return }
                self.comment = comment
                self.commentSubject.send(comment)
                let maximumLimitCount = FloatingCommentTextView.Const.maximumLimitCount
                let limit = "\(comment.count)/\(maximumLimitCount)"
                self.limitLabel.setText(limit, attributes: Const.limitAttributes)
                self.sendButton.isHidden = comment.count <= 0
            }
            .store(in: &bag)
        
        textView.shouldWarnLimitCountPublisher
            .sink { [weak self] in
                self?.limitLabel.isHidden = $0 == false
            }
            .store(in: &bag)
    }
    
    private enum Const {
        static let bottomInset: CGFloat = 10
        static let limitAttributes = Typography.Attributes(
            style: .detail3,
            weight: .medium,
            textColor: .winey_red500
        )
    }
}
