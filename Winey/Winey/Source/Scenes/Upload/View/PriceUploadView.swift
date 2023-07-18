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

    // MARK: - UI Components
    var textContentView = WITextFieldView(price: "0", label: .won)
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setLayout() {
        addSubviews(textContentView)
        
        textContentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
}
