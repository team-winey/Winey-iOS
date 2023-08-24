//
//  ContentsWriteView.swift
//  Winey
//
//  Created by 김응관 on 2023/07/13.
//

import Combine
import UIKit

import DesignSystem
import SnapKit

class ContentsWriteView: UIView {
    
    // MARK: - Property
    /// placeholder: textView의 placeholder 문구
    /// textSendClosure:  선택된 이미지객체를 ViewController로 전달하기 위해 사용되는 클로저
    private let placeholder = "Ex) 버스 타고 가는 길을 운동 삼아 20분 일찍 일어나 걸어갔어요!"
    var textSendClousre: ((_ data: String) -> Void)?
    
    var textCountPublisher = PassthroughSubject<(Int, Bool), Never>()
    
    // MARK: - UI Components
    
    /// textView: 절약 내용을 작성하는 textView
    /// textNum: 텍스트 뷰 길이를 보여주는 label 뷰
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.setText(placeholder, attributes: Const.textViewPlaceholderAttributes)
        textView.tintColor = .winey_purple400
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 17, bottom: 54, right: 17)
        textView.makeCornerRound(radius: 5)
        textView.backgroundColor = .winey_gray0
        return textView
    }()
    
    private let textNum: UILabel = {
        let label = UILabel()
        label.setText("(0/36)", attributes: Const.textViewPlaceholderAttributes)
        return label
    }()
    
    private let warningText: UILabel = {
        let label = UILabel()
        label.setText("5자 이상 작성해 주세요",
                      attributes: .init(style: .body3, weight: .medium, textColor: .winey_red500)
        )
        label.isHidden = true
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
        addSubviews(textView, textNum, warningText)
        
        textView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(110)
        }
        
        textNum.snp.makeConstraints {
            $0.top.equalTo(textView.snp.top).offset(81)
            $0.trailing.equalTo(textView.snp.trailing).inset(14)
            $0.bottom.equalTo(textView.snp.bottom).offset(-14)
        }
        
        warningText.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(4)
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
        setColor(textView.text.count)
        textCountPublisher.send((textView.text.count, textView.text == placeholder))
    }
    
    /// textViewDidEndEditing: 텍스트 뷰의 편집이 종료되었을때의 동작을 정의한 함수
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .winey_gray400
        } else {
            textView.textColor = .winey_gray900
            setColor(textView.text.count)
            
            if textView.text.count > 36 {
                textView.text.removeLast()
                textNum.text = "(36/36)"
            }
        }
        textView.makeBorder(width: 1, color: .winey_gray200)
        textCountPublisher.send((textView.text.count, textView.text == placeholder))
    }
    
    /// textViewDidChange: 텍스트 뷰가 편집되었을때의 동작을 정의한 함수
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 36 { textView.resignFirstResponder() }
        
        textSendClousre?(textView.text ?? "")
        textCountPublisher.send((textView.text.count, textView.text == placeholder))
    }
    
    func resetContents() {
        textView.text = nil
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
            let newLength = textView.text.count - range.length + text.count
            let koreanMaxCount = 37
            
            if newLength > koreanMaxCount {
                let overflow = newLength - koreanMaxCount
                if text.count < overflow {
                    return true
                }
                let index = text.index(text.endIndex, offsetBy: -overflow)
                let newText = text[..<index]
                guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return false }
                guard let endPosition = textView.position(from: textView.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
                guard let textRange = textView.textRange(from: startPosition, to: endPosition) else { return false }
                    
                textView.replace(textRange, withText: String(newText))
                textNum.text = "(36/36)"
                
                return false
            } else {
                setColor(newLength)
                textNum.text = "(\(newLength)/36)"
                return true
            }
        }
    }
    
    func setColor(_ count: Int) {
        if textView.isFirstResponder {
            switch count {
            case 1..<5:
                textView.makeBorder(width: 1, color: .winey_red500)
                warningText.isHidden = false
            default:
                textView.makeBorder(width: 1, color: .winey_purple400)
                warningText.isHidden = true
            }
        } else {
            textView.makeBorder(width: 1, color: .winey_gray200)
            warningText.isHidden = true
        }
    }
}

/// textView의 폰트와 글자수알려주는 label의 폰트를 지정
extension ContentsWriteView {
    enum Const {
        static let textViewPlaceholderAttributes = Typography.Attributes(
            style: .body2,
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
