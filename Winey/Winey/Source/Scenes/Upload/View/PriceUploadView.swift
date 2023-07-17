//
//  PriceUploadView.swift
//  Winey
//
//  Created by 김응관 on 2023/07/14.
//

import UIKit
import Foundation

import DesignSystem
import SnapKit

class PriceUploadView: UIView {
    
    // MARK: - Properties
    var feedPrice: Int64 = 0
    
    var sendPriceClosure: ((_ data: Int64) -> Void)?

    // MARK: - UI Components
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.placeholder = "0"
        field.font = Typography.font(style: .headLine2, weight: .Bold)
        field.tintColor = .winey_purple400
        field.textColor = .winey_gray500
        field.textAlignment = .right
        field.addLeftPadding(width: 48)
        field.addRightPadding(width: 38)
        field.makeCornerRound(radius: 5)
        field.makeBorder(width: 1, color: .winey_gray200)
        field.keyboardType = .numberPad
        return field
    }()
    
    private lazy var won: UILabel = {
        let label = UILabel()
        label.setText("원", attributes: Const.wonAttributes)
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(_ responder: Bool) {
        if responder {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    func setUI() {
        textField.delegate = self
        self.textField.addTarget(self, action: #selector(textfieldDidChange), for: .editingChanged)
    }
    
    func setLayout() {
        
        addSubviews(textField, won)
        
        textField.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        won.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalTo(textField.snp.centerY)
            $0.width.equalTo(16)
        }
    }
    
    func makeComma() {
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
        
        feedPrice = answer
        self.textField.text = answer.addCommaToString()
    }
    
    
    @objc
    func textfieldDidChange(_ sender: UITextField) {
        makeComma()
        
        guard let text = textField.text else { return }
        if text == "0" {
            textField.text = ""
        }
        
        sendPriceClosure?(Int64(feedPrice))
    }
}

extension PriceUploadView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.makeBorder(width: 1, color: .winey_purple400)
        textField.textColor = .winey_purple400
        
        if let pure = textField.text {
            if pure == "0" {
                textField.text = nil
                textField.placeholder = ""
            }
        }
    
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.makeBorder(width: 1, color: .winey_gray200)
        textField.textColor = .winey_gray500
        
        
        if ((textField.text?.isEmpty) != nil) {
            textField.placeholder = "0"
        }
    }
    
    // 글자수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var price: Int = 0
        
        if let pureText = textField.text {
            price = pureText.count + string.count - range.length
        }
        return !(price > 12)
    }
}

private extension PriceUploadView {
    enum Const {
        static let wonAttributes = Typography.Attributes(
            style: .headLine4,
            weight: .bold,
            textColor: .winey_gray900
        )
    }
}
