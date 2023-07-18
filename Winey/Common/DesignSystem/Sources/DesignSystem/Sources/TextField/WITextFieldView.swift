//
//  File.swift
//  
//
//  Created by 김응관 on 2023/07/17.
//

import UIKit

import SnapKit

public final class WITextFieldView: UIView {
    private let unit: UILabel = UILabel()
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
    
    public var label: Unit?
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: Const.textFieldHeight)
    }
    
    public init(price: String? = nil, label: Unit? = nil) {
        self.label = label
        self.price = price
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func becomeFirstResponder() {
        textField.becomeFirstResponder()
    }
    
    public func resignFirstResponder() {
        textField.resignFirstResponder()
    }
}

extension WITextFieldView {
    
    private func setUI() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textfieldDidChange), for: .editingChanged)
        
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
        
        unit.setText(label?.text, attributes: Const.labelAttributes)
    }
    
    private func setLayout() {
        addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addSubview(unit)
        
        unit.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalTo(textField.snp.centerY)
            $0.width.equalTo(16)
        }
    }
    
    private func makeComma() {
        guard let str = self.textField.text else {
            textField.placeholder = ""
            return
        }

        var answer: Int64 = 0

        if str.count > 3 {
            answer = Int64(str.replacingOccurrences(of: ",", with: "")) ?? 0
        } else {
            answer = Int64(str) ?? 0
        }

        self.textField.text = answer.addCommaToString()
    }
    
}

extension WITextFieldView {
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

// 텍스트필드, 뷰 익스텐션

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
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = Const.activeColor
        textField.makeBorder(width: Const.borderWidth, color: Const.activeColor)
        
        if let pure = textField.text {
            if pure == "0" { textField.text = nil }
            else { textField.text = pure }
        }
    }
    
    @objc private func textfieldDidChange(_ sender: UITextField) {
        makeComma()

        guard let text = textField.text else { return }
        if text == "0" {
            textField.text = ""
        } else {
            textField.text = text
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.makeBorder(width: Const.borderWidth, color: Const.inactivateBorderColor)
        textField.textColor = Const.inactivateTextColor
        
        
        if ((textField.text?.isEmpty) != nil) {
            textField.placeholder = "0"
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        
        var price: Int = 0
        
        if let pureText = textField.text {
            price = pureText.count + string.count - range.length
        }
        return !(price > 12)
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func makeShadow(radius: CGFloat, offset: CGSize, opacity: Float) {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    func makeCornerRound(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func makeBorder(width: CGFloat, color: UIColor ) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    
    // UIView -> UIImage로의 변환을 위한 함수
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func makeCornerCircle() {
        let height = self.frame.height
        layer.cornerRadius = height / 2
        clipsToBounds = true
    }
}

extension Int64 {
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
}
