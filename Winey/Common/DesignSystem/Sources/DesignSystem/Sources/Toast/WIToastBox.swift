//
//  File.swift
//  
//
//  Created by 김응관 on 2023/08/15.
//

import UIKit

import SnapKit

public final class WIToastBox: UIView {
    
    // MARK: - Properties
    
    private let fontStyle: Typography.Attributes = .init(style: .body3, weight: .medium, textColor: .winey_gray0)
    private var toastType: WIToastType
    
    // MARK: - UI Components
    
    private let iconView = UIImageView()
    private let text = UILabel()
    
    // MARK: - Init func
    
    public init(toastType: WIToastType) {
        self.toastType = toastType
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUI() {
        backgroundColor = .winey_gray750
        layer.cornerRadius = 4
        makeShadow(radius: 4, offset: CGSize(width: 0, height: 4), opacity: 0.25)
        iconView.image = toastType.icon
        text.setText(toastType.text, attributes: self.fontStyle)
        text.textAlignment = .left
    }
    
    private func setLayout() {
        addSubviews(iconView, text)
        
        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
        
        text.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(8)
            $0.verticalEdges.equalToSuperview().inset(14)
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
