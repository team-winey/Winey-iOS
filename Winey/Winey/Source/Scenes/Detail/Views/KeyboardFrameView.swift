//
//  KeyboardFrameView.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/09.
//

import Combine
import SnapKit
import UIKit

public final class KeyboardFrameView: UIView {
    private var heightConstraint: Constraint?
    private let keyboardWillHideNotificationSubject = PassthroughSubject<CGFloat, Never>()
    private let keyboardWillShowNotificationSubject = PassthroughSubject<CGFloat, Never>()
    private var bag = Set<AnyCancellable>()
    
    public var keyboardWillHideNotification: AnyPublisher<CGFloat, Never> {
        keyboardWillHideNotificationSubject.eraseToAnyPublisher()
    }
    public var keyboardWillShowNotification: AnyPublisher<CGFloat, Never> {
        keyboardWillShowNotificationSubject.eraseToAnyPublisher()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraint()
        bindKeyboardFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraint() {
        snp.makeConstraints { make in
            self.heightConstraint = make.height.equalTo(0).constraint
        }
    }
    
    private func bindKeyboardFrame() {
        Publishers.Merge(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification),
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        ).compactMap { notification in
            if notification.name == UIResponder.keyboardWillHideNotification { return .zero }
            return notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        }.sink { [weak self] (keyboardFrame: CGRect) in
            let height = keyboardFrame.height
            self?.updateFrame(keyboardFrame)
            self?.sendNotification(hasKeyboard: height > 0, keyboardHeight: height)
        }
        .store(in: &bag)
    }
    
    private func updateFrame(_ frame: CGRect) {
        heightConstraint?.update(offset: frame.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.superview?.layoutSubviews()
        })
    }
    
    private func sendNotification(hasKeyboard: Bool, keyboardHeight: CGFloat) {
        if hasKeyboard  { keyboardWillShowNotificationSubject.send(keyboardHeight) }
        else            { keyboardWillHideNotificationSubject.send(keyboardHeight) }
    }
}
