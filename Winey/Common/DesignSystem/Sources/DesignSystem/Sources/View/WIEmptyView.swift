//
//  File.swift
//  
//
//  Created by 김응관 on 2023/07/21.
//

import UIKit

import SnapKit

public final class WIEmptyView: UIView {
        
    private let emptyImg: UIImageView = {
        let img = UIImageView()
        img.image = .Img.img_empty
        img.sizeToFit()
        return img
    }()
    
    private let mainText: UILabel = {
        let main = UILabel()
        main.setText("아직 없사옵니다", attributes: Typography.Attributes(
            style: .headLine,
            weight: .bold,
            textColor: .winey_gray900)
        )
        return main
    }()
    
    private let subText: UILabel = {
        let main = UILabel()
        main.setText("황제가 되기 위해 얼른 하나 채워보시지요", attributes: Typography.Attributes(
            style: .body3,
            weight: .medium,
            textColor: .winey_gray500)
        )
        return main
    }()
    
    private let textStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 11
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    private let totalStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 14
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    func setUI() {
        backgroundColor = .winey_gray0
    }
    
    func setLayout() {
        addSubview(totalStack)
        
        textStack.addArrangedSubview(mainText)
        textStack.addArrangedSubview(subText)
        
        totalStack.addArrangedSubview(emptyImg)
        totalStack.addArrangedSubview(textStack)
        
        totalStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyImg.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.width.equalTo(342)
        }
        
        textStack.snp.makeConstraints {
            $0.top.equalTo(emptyImg.snp.bottom)
            $0.width.equalTo(emptyImg.snp.width)
            $0.bottom.equalToSuperview()
        }
        
        mainText.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalTo(171)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        
        subText.snp.makeConstraints {
            $0.top.equalTo(mainText.snp.bottom)
            $0.width.equalTo(217)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
