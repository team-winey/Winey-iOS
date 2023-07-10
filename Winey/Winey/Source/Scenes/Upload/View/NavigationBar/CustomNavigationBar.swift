//
//  CustomNavigationBar.swift
//  AppZam_Practice
//
//  Created by 김응관 on 2023/07/08.
//

import UIKit

import SnapKit

class CustomNavigationBar: UIView {
    
    // MARK: - Properties
    private var leadInset: CGFloat = 0.0
    private var barType: String = ""
    private var itemWidth: CGFloat = 0.0
    private var itemHeight: CGFloat = 0.0
    
    // MARK: - UI Components
    
    lazy var leftButtons: UIButton = {
        let btn = UIButton()
        btn.sizeToFit()
        return btn
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.font = .head_b18
        return title
    }()
    
    // MARK: - Life Cycle
    
    init(barType: NavigationBarType) {
        super.init(frame: .zero)
        setUI(type: barType)
        setLayout(type: barType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setUI(type: NavigationBarType) {
        
        backgroundColor = .white
        
        switch type {
        case .uploadDismissBar:
            leftButtons.setImage(.Upload.cancel, for: .normal)
            leadInset = type.leading
            barType = type.rawValue
            itemWidth = type.width
            itemHeight = type.height
        case .backBar:
            leftButtons.setImage(.Upload.back, for: .normal)
            leadInset = type.leading
            barType = type.rawValue
            itemWidth = type.width
            itemHeight = type.height
        }
    }
    
    func setLayout(type: NavigationBarType) {
        
        if type.rawValue != "myPageBar" {
            addSubview(leftButtons)
            
            leftButtons.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(leadInset)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(itemWidth)
                $0.height.equalTo(itemHeight)
            }
        } else {
            addSubview(title)
            
            title.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
        }
    }
}
