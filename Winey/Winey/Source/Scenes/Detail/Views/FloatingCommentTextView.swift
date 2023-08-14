//
//  FloatingCommentTextView.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/09.
//

import Combine
import UIKit

import DesignSystem
import SnapKit

final class FloatingCommentTextView: UITextView {
    private var placeholderLabel: UILabel?
    
    private let commentSubject = CurrentValueSubject<String, Never>("")
    private let shouldWarnLimitCountSubject = CurrentValueSubject<Bool, Never>(false)
    
    var placeholderText: String? {
        get { placeholderLabel?.text }
        set { configurePlaceholderLabel(newValue) }
    }
    
    var commentPublisher: AnyPublisher<String, Never> {
        commentSubject.eraseToAnyPublisher()
    }
    
    var shouldWarnLimitCountPublisher: AnyPublisher<Bool, Never> {
        shouldWarnLimitCountSubject.eraseToAnyPublisher()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateText(_ text: String?) {
        defer { updatePlaceholder() }
        
        guard let text,
              text.isEmpty == false
        else { return }
        
        attributedText = Typography.build(
            string: text,
            attributes: Const.defaulAttributes
        )
    }
    
    private func updatePlaceholder() {
        placeholderLabel?.isHidden = text.isEmpty == false
    }
}

extension FloatingCommentTextView {
    private func setupUI() {
        autocorrectionType = .no
        spellCheckingType = .no
        isScrollEnabled = false
        textContainer.lineFragmentPadding = .zero
        textContainerInset = Const.textInset
        tintColor = .winey_gray900
        typingAttributes = Const.defaulAttributes.dictionary
        delegate = self
        
        snp.makeConstraints { make in
            make.height.equalTo(Const.minimumViewHeight)
        }
    }
    
    private func configurePlaceholderLabel(_ placeholder: String?) {
        let label: UILabel
        if let placeholderLabel {
            label = placeholderLabel
        } else {
            label = UILabel()
            label.numberOfLines = 0
            self.placeholderLabel = label
        }
        
        label.setText(placeholder, attributes: Const.placeholderAttributes)
        
        if label.superview == nil {
            addSubview(label)
        }
        
        label.snp.remakeConstraints { make in
            let topOffset = textContainerInset.top
            make.top.equalToSuperview().offset(topOffset)
            make.leading.equalToSuperview().offset(textContainerInset.left)
        }
        
        updatePlaceholder()
    }
}

extension FloatingCommentTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard var newText = textView.text else { return }
         
        if textView.text.count > Const.maximumLimitCount {
            newText = String(newText.prefix(Const.maximumLimitCount))
        }
        
        updateTextViewScrollableIfNeeded(text: newText)
        
        let selectedRange = textView.selectedRange
        updateText(newText)
        textView.selectedRange = selectedRange
        commentSubject.send(newText)
        
        let shouldWarn = newText.count >= Const.minimumWarningCount
        shouldWarnLimitCountSubject.send(shouldWarn)
    }
    
    private func updateTextViewScrollableIfNeeded(text: String) {
        let height = Typography.height(
            string: text,
            attributes: Const.defaulAttributes,
            availableWidth: self.frame.width,
            maxLines: Const.maxLineCount
        )
        let firstLineHeight = Typography.height(
            string: ".",
            attributes: Const.defaulAttributes,
            availableWidth: self.frame.width,
            maxLines: 1
        )
        
        if Int(height / firstLineHeight) == Const.maxLineCount {
            self.isScrollEnabled = true
        } else {
            self.isScrollEnabled = false
        }
        
        self.snp.updateConstraints { make in
            let height = max(Const.minimumViewHeight, height)
            make.height.equalTo(height)
        }
    }
}

extension FloatingCommentTextView {
    enum Const {
        static let maxLineCount: Int = 4
        static let minimumWarningCount: Int = 100
        static let maximumLimitCount: Int = 500
        static let minimumViewHeight: CGFloat = 22
        static let textInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        static let defaulAttributes = Typography.Attributes(
            style: .body2,
            weight: .medium,
            textColor: .winey_gray900
        )
        static let placeholderAttributes = Typography.Attributes(
            style: .body2,
            weight: .medium,
            textColor: .winey_gray400
        )
    }
}

extension Typography.Attributes {
    var dictionary: [NSAttributedString.Key: Any] {
        Typography.build(string: " ", attributes: self)
            .attributes(at: 0, effectiveRange: nil)
    }
}
