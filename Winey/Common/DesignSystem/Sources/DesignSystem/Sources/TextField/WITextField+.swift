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
    
    private lazy var name: String = "" {
        didSet { stringPublisher.send(name) }
    }
    
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
        if type.type == "String" {
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
        textField.makeBorder(width: Size.borderWidth.rawValue, color: Color.errorColor.color)
        textField.textColor = Color.errorColor.color
    }
    
    public func makeActiveView() {
        textField.makeBorder(width: Size.borderWidth.rawValue, color: Color.activeColor.color)
        textField.textColor = type.activeTextColor
    }
    
    public func makeInactiveView() {
        textField.makeBorder(width: Size.borderWidth.rawValue, color: Color.inactiveBorder.color)
        textField.textColor = Color.inactiveText.color
    }
}

extension WITextFieldView: UITextFieldDelegate {
    
    /// textFieldDidBeginEditing: textField의 편집이 시작될 때의 동작을 정의한 함수
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = type.activeTextColor
        textField.makeBorder(width: Size.borderWidth.rawValue, color: Color.activeColor.color)
        
        if type.type == "Int" {
            pricePublisher.send(price)
            
            if let pure = textField.text {
                if pure == type.placeholder { textField.text = nil }
                else { textField.text = pure }
            }
        } else {
            stringPublisher.send(name)
            
            if let pure = textField.text {
                textField.text = pure
            } else {
                textField.text = ""
            }
        }
    }
    
    /// textfieldDidChange: textField의 text가 변경되었을때 작동하는 함수
    @objc
    private func textfieldDidChange(_ sender: UITextField) {
        
        if type.type == "Int" {
            makeComma()
        }
        
        guard let text = textField.text else { return }
        if text == type.placeholder {
            textField.text = ""
        } else {
            textField.text = text
        }
        
        if type.type == "String" {
            countPublisher.send(text.count)
        }
    }
    
    /// textFieldDidEndEditing: textField의 편집이 종료되었을때 작동하는 함수
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if ((textField.text?.isEmpty) != nil) {
            textField.placeholder = type.placeholder
            self.makeInactiveView()
        }
        textFieldDidEndEditingPublisher.send(Void())
    }
    
    /// textField: 텍스트필드에 새로운 문자가 추가되었을때 text를 바꿔주는 함수
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        var price: Int = 0
        
        if let pureText = textField.text {
            price = pureText.count + string.count - range.length
        }
        
        return !(price > type.textLength)
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
        case errorColor
        case cursorColor
        case backgroundColor
        
        var color: UIColor {
            switch self {
            case .backgroundColor:
                return .winey_gray0
            case .inactiveBorder:
                return .winey_gray200
            case .activeColor, .cursorColor:
                return .winey_purple400
            case .errorColor:
                return .winey_red500
            case .inactiveText:
                return .winey_gray400
            }
        }
    }
}
