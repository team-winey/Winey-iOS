//
//  File.swift
//  
//
//  Created by 김응관 on 2023/08/15.
//

import Combine
import UIKit

import SnapKit

public final class WIToastBox: UIView {
    
    // MARK: - Properties
    
    // 폰트 스타일과 toastType
    private let fontStyle: Typography.Attributes = .init(style: .body3, weight: .medium, textColor: .winey_gray0)
    private let toastType: WIToastType
    
    private var bag = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let iconView = UIImageView()
    private let text = UILabel()
    
    // MARK: - Init func
    
    public init(toastType: WIToastType) {
        self.toastType = toastType
        super.init(frame: .zero)
        setUI()
        setLayout()
        toastAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUI() {
        backgroundColor = .winey_gray750.withAlphaComponent(0.9)
        layer.cornerRadius = 4
        makeShadow(radius: 4, offset: CGSize(width: self.bounds.width, height: self.bounds.height+4), opacity: 0.25)
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
    
    func toastAction() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
                self.alpha = 0.0
            }, completion: {_ in
                self.removeFromSuperview()
            })
        })
    }
}

extension UIView {
    func makeShadow(radius: CGFloat, offset: CGSize, opacity: Float) {
        layer.shadowColor = UIColor.winey_gray900.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}

extension Notification.Name {
    /// 피드 업로드후 노티
    static let feedUploadResult = Notification.Name(rawValue: "feedUploadResult")
}
