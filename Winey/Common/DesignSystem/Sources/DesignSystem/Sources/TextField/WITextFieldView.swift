//
//  File.swift
//  
//
//  Created by 김응관 on 2023/07/17.
//

import UIKit

import SnapKit

public final class WITextFieldView: UIView {
    
    // MARK: - Properties
    
    /// uploadPrice: 입력된 금액을 UploadViewController로 전달해주는 클로져
    /// unit: "원", "일" 등 텍스트필드 뒤에 붙을 단위를 표시해주는 label 객체
    /// textField: 금액및 일수를 입력하는 텍스트필드
    /// price: textField의 text에 들어갈 문자열
    /// label: textField의 숫자 오른쪽에 들어갈 단위의 타입을 담은 변수
    public var uploadPrice: ((_ data: Int) -> Void)?
    
    private let unitLabel: UILabel = UILabel()
    private let textField: UITextField = UITextField()
    
    public var price: String? {
        didSet {
            if price == "0" || price == nil {
                textField.placeholder = ""
                textField.text = ""
            } else {
                textField.text = price
            }
        }
    }
    
    public let label: Unit?
    
    public let textLength: Int?
    
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: Const.textFieldHeight)
    }
    
    public init(price: String? = nil, label: Unit? = nil, textLength: NumberType? = nil) {
        self.label = label
        self.price = price
        self.textLength = textLength?.number
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// become, resign: 텍스트필드가 firstResponder가 될지 말지 결정해주는 함수
    public func become() {
        textField.becomeFirstResponder()
    }
    
    public func resign() {
        textField.resignFirstResponder()
    }
}

extension WITextFieldView {
    
    /// setUI: TextField의 속성값 지정
    private func setUI() {
        setAddTarget()
        
        textField.delegate = self
        textField.placeholder = "0"
        textField.tintColor = Const.tintColor
        textField.textAlignment = .right
        textField.keyboardType = .numberPad
        textField.textColor = Const.inactivateTextColor
        textField.font = Typography.font(style: .headLine2, weight: .Bold)
        textField.addLeftPadding(width: Const.leftPadding)
        textField.addRightPadding(width: Const.rightPadding)
        textField.makeCornerRound(radius: Const.cornerRadius)
        textField.makeBorder(width: Const.borderWidth, color: Const.inactivateBorderColor)
        
        unitLabel.setText(label?.text, attributes: Const.labelAttributes)
    }
    
    /// setAddTarget: 텍스트필드가 편집 중일때 액션함수 작동하게끔 설정
    private func setAddTarget() {
        textField.addTarget(self, action: #selector(textfieldDidChange), for: .editingChanged)
    }
    
    private func setLayout() {
        addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(unitLabel)
        
        unitLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalTo(textField.snp.centerY)
            $0.width.equalTo(16)
        }
    }
    
    /// makeComma: 텍스트필드의 text에 콤마를 붙여주는 함수
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
        self.textField.text = answer.addCommaToString()
    }
    
}

extension WITextFieldView {
    /// Const: 커스텀 텍스트필드 제작에 필요한 여러 레이아웃, 속성 값들을 단일 상수로 선언
    enum Const {
        
        static let unitTrailing: CGFloat = 18.0
        static let textFieldHeight: CGFloat = 56.0
        static let labelWidth: CGFloat = 16.0
        static let leftPadding: CGFloat = 48.0
        static let rightPadding: CGFloat = 38
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 1
        
        static let tintColor = UIColor.winey_purple400
        static let activeColor = UIColor.winey_purple400
        
        static let unitColor = UIColor.winey_gray900
        
        static let inactivateBorderColor = UIColor.winey_gray200
        static let inactivateTextColor = UIColor.winey_gray500
        
        static let inactiveTextFieldAttributes = Typography.Attributes(
            style: .headLine2,
            weight: .bold,
            textColor: inactivateTextColor
        )
        
        static let activeTextFieldAttributes = Typography.Attributes(
            style: .headLine2,
            weight: .bold,
            textColor: activeColor
        )
        
        static let labelAttributes = Typography.Attributes(
            style: .headLine4,
            weight: .bold,
            textColor: unitColor
        )
    }
}

/// 텍스트필드 양옆에 여백을 주는 함수
extension UITextField {
    func addLeftPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func addRightPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension WITextFieldView: UITextFieldDelegate {
    
    /// textFieldDidBeginEditing: textField의 편집이 시작될 때의 동작을 정의한 함수
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = Const.activeColor
        textField.makeBorder(width: Const.borderWidth, color: Const.activeColor)
        
        if let pure = textField.text {
            if pure == "0" { textField.text = nil }
            else { textField.text = pure }
        }
    }
    
    /// textfieldDidChange: textField의 text가 변경되었을때 작동하는 함수
    @objc
    private func textfieldDidChange(_ sender: UITextField) {
        
        if textLength == 12 {
            makeComma()
        }

        guard let text = textField.text else { return }
        if text == "0" {
            textField.text = ""
        } else {
            textField.text = text
        }
    }
    
    /// textFieldDidEndEditing: textField의 편집이 종료되었을때 작동하는 함수
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.makeBorder(width: Const.borderWidth, color: Const.inactivateBorderColor)
        textField.textColor = Const.inactivateTextColor
        
        if ((textField.text?.isEmpty) != nil) {
            textField.placeholder = "0"
        }
    }
    
    /// textField: 텍스트필드에 새로운 문자가 추가되었을때 text를 바꿔주는 함수
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        
        var price: Int = 0
        
        if let pureText = textField.text {
            price = pureText.count + string.count - range.length
        }
        return !(price > textLength ?? 0)
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
    public enum Unit {
        case won
        case day
        case none
        
        var text: String? {
            switch self {
            case .won:
                return "원"
            case .day:
                return "일"
            case .none:
                return nil
            }
        }
    }
    
    public enum NumberType {
        case price
        case day
        
        var number: Int? {
            switch self{
            case .price:
                return 12
            case .day:
                return 2
            }
        }
    }
}
