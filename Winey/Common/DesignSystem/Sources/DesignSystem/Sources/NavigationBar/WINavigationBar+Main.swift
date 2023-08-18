//
//  WIMainNavigationBar.swift
//  DesignSystem
//
//  Created by Woody Lee on 2023/07/14.
//

import UIKit

import SnapKit

public final class WIMainNavigationBar: UIView {
    
    var alarmButtonClosure: (() -> Void)?
    
    private let imageView = UIImageView()
    private let alarmButton = UIButton()
    private var bottomSeparatorView = UIView()
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: WINavigationBar.Const.navigationBarHeight)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUI() {
        self.backgroundColor = .winey_gray0
        bottomSeparatorView.backgroundColor = .winey_gray200
        imageView.image = .Img.appbar_logo?.resizing(width: 95, height: 45)
        
        alarmButton.setImage(.Icon.alarm_default, for: .normal)
        alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
    }
    
    private func setLayout() {
        addSubview(imageView)
        addSubview(alarmButton)
        addSubview(bottomSeparatorView)

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().inset(6)
            make.leading.equalToSuperview().offset(13)
        }
        
        alarmButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
            make.size.equalTo(24)
        }
        
        bottomSeparatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @objc
    private func alarmButtonTapped() {
        self.alarmButtonClosure?()
    }
}
