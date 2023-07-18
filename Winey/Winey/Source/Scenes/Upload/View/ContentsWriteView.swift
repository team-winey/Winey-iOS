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
    /// placeholder: textView의 placeholder 문구
    /// textSendClosure:  선택된 이미지객체를 ViewController로 전달하기 위해 사용되는 클로저
    private let placeholder = "Ex) 버스 타고 가는 길을 운동 삼아 20분 일찍 일어나 걸어갔어요!"
    var textSendClousre: ((_ data: String) -> Void)?
    
    // MARK: - UI Components
    
    /// textView: 절약 내용을 작성하는 textView
    /// textNum: 텍스트 뷰 길이를 보여주는 label 뷰
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.setText(placeholder, attributes: Const.textViewPlaceholderAttributes)
        textView.tintColor = .winey_purple400
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 17, bottom: 54, right: 17)
        textView.makeCornerRound(radius: 5)
        textView.makeBorder(width: 1, color: .winey_gray200)
        return textView
    }()
    
    private let textNum: UILabel = {
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
    
    /// configure: textView가 firstResponder가 될지 말지 지정해주는 함수
    func configure(_ responder: Bool) {
        if responder {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
    }
    
    private func setLayout() {
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
    
    /// textViewDidBeginEditing: 텍스트 뷰의 편집이 시작되었을때의 동작을 정의한 함수
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.makeBorder(width: 1, color: .winey_purple400)
        
        if textView.text == placeholder {
            textView.textColor = .winey_gray900
            textView.text = nil
        }
    }
    
    /// textViewDidEndEditing: 텍스트 뷰의 편집이 종료되었을때의 동작을 정의한 함수
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .winey_gray400
        } else {
            textView.textColor = .winey_gray900
        }
        textView.makeBorder(width: 1, color: .winey_gray200)
    }
    
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        textView.endEditing(true)
//        return true
//    }
    
    /// textViewDidChange: 텍스트 뷰가 편집되었을때의 동작을 정의한 함수
    func textViewDidChange(_ textView: UITextView) {
        textSendClousre?(textView.text ?? "")
    }
    
    /// textView: 텍스트뷰에 새로운 글자가 입력되었을때 문자열을 변경해주는 함수
    /// 개행문자 입력시 문자열 업데이트 안되도록 처리해주는 코드 추가
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

/// textView의 폰트와 글자수알려주는 label의 폰트를 지정
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
