//
//  ContentsWriteView.swift
//  Winey
//
//  Created by 김응관 on 2023/07/13.
//

import UIKit

import DesignSystem
import SnapKit

class ContentsWriteView: UIView {
    
    // MARK: - Property
    private let placeholder = "Ex) 버스 타고 가는 길을 운동 삼아 20분 일찍 일어나 걸어갔어요!"
    
    var feedTitle: String?
    
    // 선택된 이미지객체를 ViewController로 전달하기 위해 사용되는 클로저
    var textSendClousre: ((_ data: String) -> Void)?
    
    // MARK: - UI Components
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.setText(placeholder, attributes: Const.textViewPlaceholderAttributes)
        textView.tintColor = .winey_purple400
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 17, bottom: 54, right: 17)
        textView.makeCornerRound(radius: 5)
        textView.makeBorder(width: 1, color: .winey_gray200)
        return textView
    }()
    
    private lazy var textNum: UILabel = {
        let label = UILabel()
        label.setText("(0/36)", attributes: Const.textViewPlaceholderAttributes)
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textView.delegate = self

        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(_ responder: Bool) {
        if responder {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
    }
    
    func setLayout() {
        addSubviews(textView, textNum)
        
        textView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(110)
        }
        
        textNum.snp.makeConstraints {
            $0.top.equalTo(textView.snp.top).offset(81)
            $0.trailing.equalTo(textView.snp.trailing).inset(14)
            $0.bottom.equalTo(textView.snp.bottom).offset(-14)
        }
    }
}

extension ContentsWriteView: UITextViewDelegate {
    
    // placeholder settings
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.makeBorder(width: 1, color: .winey_purple400)
        
        if textView.text == placeholder {
            textView.textColor = .winey_gray900
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .winey_gray400
        } else {
            textView.textColor = .winey_gray900
        }
        textView.makeBorder(width: 1, color: .winey_gray200)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.endEditing(true)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textSendClousre?(textView.text ?? "")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        if text == "\n" {
            textNum.text = "(\(currentText.count)/36)"
            textView.resignFirstResponder()
            return false
        } else {
            let changedText = currentText.replacingCharacters(in: stringRange, with: text)
            textNum.text = "(\(changedText.count)/36)"
            return changedText.count <= 35
        }
    }
}

extension ContentsWriteView {
    enum Const {
        static let textViewPlaceholderAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray400
        )
        
        static let textViewLengthAttributes = Typography.Attributes(
            style: .detail,
            weight: .medium,
            textColor: .winey_gray400
        )
    }
}

extension ContentsWriteView {
    enum Const {
        static let textViewPlaceholderAttributes = Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray400
        )
        
        static let textViewLengthAttributes = Typography.Attributes(
            style: .detail,
            weight: .medium,
            textColor: .winey_gray400
        )
    }
}
