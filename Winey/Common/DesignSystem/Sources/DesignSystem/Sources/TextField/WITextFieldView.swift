//
//  File.swift
//  
//
//  Created by 김응관 on 2023/08/17.
//

import Combine
import UIKit

import SnapKit

public final class WITextFieldView: UIView {
    private var type: WITextFieldType
    
    private let label = UILabel()
    private let textField = UITextField()
    
    public var uploadPrice: ((_ data: Int) -> Void)?
    public var uploadName: ((_ data: String) -> Void)?
    
    public let textFieldDidEndEditingPublisher = PassthroughSubject<Void, Never>()
    
    public lazy var pricePublisher = PassthroughSubject<Int, Never>()
    public lazy var countPublisher = PassthroughSubject<Int, Never>()
    public lazy var stringPublisher = PassthroughSubject<String, Never>()
    
    public lazy var bag = Set<AnyCancellable>()
    
    private lazy var price: Int = 0 {
        didSet { pricePublisher.send(price) }
    }
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: Size.height.rawValue)
    }
    
    // MARK: - Init func
    
    public init(type: WITextFieldType) {
        self.type = type
        super.init(frame: .zero)
        setTextField()
        setLayout()
        setLabel(0)
        bind()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setTextField() {
        textField.delegate = self
        textField.addLeftMargin(width: type.textLeftPadding)
        textField.addRightMargin(width: type.textRightPadding)
        textField.makeCornerRound(radius: Size.cornerRadius.rawValue)
        textField.makeBorder(width: Size.borderWidth.rawValue, color: Color.inactiveBorder.color)
        textField.backgroundColor = Color.backgroundColor.color
        textField.font = type.textStyle
        textField.textColor = Color.inactiveText.color
        textField.keyboardType = type.keyboardType
        textField.textAlignment = type.textAlignment
        textField.tintColor = Color.cursorColor.color
        textField.placeholder = type.placeholder
    }
    
    private func setLabel(_ count: Int) {
        if type.keyboardType == .default {
            label.setText("(\(count)/\(type.textLength))", attributes: type.labelStyle)
        } else {
            label.setText(type.label, attributes: type.labelStyle)
        }
        
        label.textColor = type.labelColor
    }
    
    private func setAddTarget() {
        textField.addTarget(self, action: #selector(textfieldDidChange), for: .editingChanged)
    }
    
    private func bind() {
        countPublisher
            .sink { [weak self] count in
                self?.setLabel(count)
            }
            .store(in: &bag)
    }
    
    private func setLayout() {
        addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.centerY.equalTo(textField.snp.centerY)
            $0.trailing.equalToSuperview().inset(type.labelRightPadding)
            $0.width.equalTo(type.labelWidth)
        }
    }
    
    private func nameValidation(text: String) -> Bool {
        let arr = Array(text)
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            var index = 0
            while index < arr.count { // string 내 각 문자 하나하나 마다 정규식 체크 후 충족하지 못한것은 제거.
                let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
                if results.count == 0 {
                    return false
                } else {
                    index += 1
                }
            }
        }
        return true
    }
    
    private func makeComma() {
        guard let str = self.textField.text else {
            textField.placeholder = ""
            return
        }
        
        var answer: Int = 0
        
        if str.count > 3 {
            answer = Int(str.replacingOccurrences(of: ",", with: "")) ?? 0
        } else {
            answer = Int(str) ?? 0
        }
        
        uploadPrice?(answer)
        
        self.price = answer
        self.textField.text = answer.addCommaToString()
    }
    
    public func become() {
        textField.becomeFirstResponder()
    }
    
    public func resign() {
        textField.resignFirstResponder()
    }
    
    public func resetPrice() {
        textField.text = "0"
    }
    
    public func makeErrorView() {
        textField.makeBorder(width: Size.borderWidth.rawValue, color: Color.errorBorderColor.color)
        textField.textColor = Color.errorTextColor.color
    }
    
    public func makeActiveView() {
        textField.makeBorder(width: Size.borderWidth.rawValue, color: Color.activeColor.color)
        textField.textColor = type.activeTextColor
    }
    
    public func makeInactiveView() {
        textField.makeBorder(width: Size.borderWidth.rawValue, color: Color.inactiveBorder.color)
        textField.textColor = Color.inactiveText.color
    }
    
    public func makeSuccessView() {
        textField.makeBorder(width: Size.borderWidth.rawValue, color: Color.nickNameSuccess.color)
        textField.textColor = type.activeTextColor
    }
    
    public func changeTextLength(_ length: Int) {
        type.textLength = length
    }
    
    public func getName() -> String {
        return textField.text ?? ""
    }
}

extension WITextFieldView: UITextFieldDelegate {
    
    /// textFieldDidBeginEditing: textField의 편집이 시작될 때의 동작을 정의한 함수
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if type.keyboardType == .numberPad {
            pricePublisher.send(price)
            
            if let pure = textField.text {
                if pure == type.placeholder { textField.text = nil }
                else { textField.text = pure }
            }
        } else {
            stringPublisher.send(textField.text ?? "")
            if textField.text == nil || textField.text == "" { textField.placeholder = "" }
        }
    }
    
    /// textfieldDidChange: textField의 text가 변경되었을때 작동하는 함수
    @objc
    private func textfieldDidChange(_ sender: UITextField) {
        
        if type.keyboardType == .numberPad {
            makeComma()
            
            guard let text = textField.text else { return }
            if text == type.placeholder {
                textField.text = ""
            } else {
                textField.text = text
            }
        } else if type.keyboardType == .default {
            if let text = textField.text {
                if text.count >= type.textLength + 1 {
                    let index = text.index(text.startIndex, offsetBy: type.textLength)
                    let newString = text[text.startIndex..<index]
                    self.textField.text = String(newString)
                    countPublisher.send(type.textLength)
                    textFieldDidEndEditingPublisher.send(Void())
                    textField.resignFirstResponder()
                } else {
                    countPublisher.send(text.count)
                    stringPublisher.send(text)
                }
            }
            if textField.text == "" { textField.placeholder = "" }
        }
    }

    /// textFieldDidEndEditing: textField의 편집이 종료되었을때 작동하는 함수
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if ((textField.text?.isEmpty) != nil) {
            textField.placeholder = type.placeholder
            
            if type.keyboardType == .numberPad { self.makeInactiveView() }
        }
        textFieldDidEndEditingPublisher.send(Void())
    }
    
    /// textField: 텍스트필드에 새로운 문자가 추가되었을때 text를 바꿔주는 함수
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        if let text = self.textField.text {
            let newLength = text.count + string.count - range.length
            if type.keyboardType == .default {
                return !(newLength > type.textLength + 1)
            } else if type.textLength == 11 {
                return !(newLength > type.textLength + 3)
            } else {
                return !(newLength > type.textLength)
            }
        }
        return true
    }
}


extension UITextField {
    func addLeftMargin(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func addRightMargin(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func makeCornerRound(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func makeBorder(width: CGFloat, color: UIColor ) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}

extension Int {
    func addCommaToString() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: self))
        return result
    }
}

extension WITextFieldView {
    enum Size: CGFloat {
        case cornerRadius = 5
        case borderWidth = 1
        case height = 56
    }
    
    enum Color {
        case inactiveBorder
        case inactiveText
        case activeColor
        case errorTextColor
        case errorBorderColor
        case cursorColor
        case backgroundColor
        case nickNameSuccess
        
        var color: UIColor {
            switch self {
            case .backgroundColor:
                return .winey_gray0
            case .inactiveBorder:
                return .winey_gray200
            case .activeColor, .cursorColor:
                return .winey_purple400
            case .errorTextColor:
                return .winey_gray900
            case .errorBorderColor:
                return .winey_red500
            case .inactiveText:
                return .winey_gray500
            case .nickNameSuccess:
                return .winey_blue500
            }
        }
    }
}
