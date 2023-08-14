//
//  File.swift
//  
//
//  Created by 김응관 on 2023/08/15.
//

import UIKit

import SnapKit

final class WIToastBox: UIView {
    
    // MARK: - Properties
    
    private let backgroundColor: UIColor = .winey_gray750
    private let fontStyle: Typography.Attributes = .init(style: .body3, weight: .medium, textColor: .winey_gray0)
    private let toastType: WIToastType
    
    // MARK: - UI Components
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }()
    
    private let iconView = UIImageView()
    private let text = UILabel()
    
    // MARK: - Init func
    
    override init(toastType: WIToastType) {
        super.init(frame: .zero)
        self.toastType = toastType
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUI() {
        backgroundColor = self.backgroundColor
        cornerRadius = 4
        makeShadow(radius: 4, offset: CGSize(width: 0, height: 4), opacity: 0.25)
        iconView.image = toastType.icon.resizeWithWidth(width: 24)
        text.setText(toastType.text, attributes: self.fontStyle)
    }
    
    private func setLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(text)
        
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview().inset(19)
        }
        
        iconView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
        
        text.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}

extension UIView {
    func makeShadow(radius: CGFloat, offset: CGSize, opacity: Float) {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}
