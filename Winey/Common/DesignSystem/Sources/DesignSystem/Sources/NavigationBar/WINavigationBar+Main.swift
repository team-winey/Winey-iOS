//
//  WIMainNavigationBar.swift
//  DesignSystem
//
//  Created by Woody Lee on 2023/07/14.
//

import UIKit

import SnapKit

public final class WIMainNavigationBar: UIView {
    private let imageView = UIImageView()
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
    }
    
    private func setLayout() {
        addSubview(imageView)
        addSubview(bottomSeparatorView)

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().inset(6)
            make.leading.equalToSuperview().offset(13)
        }
        bottomSeparatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
