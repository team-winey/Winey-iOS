//
//  PriceUploadView.swift
//  Winey
//
//  Created by 김응관 on 2023/07/14.
//

import Combine
import UIKit

import DesignSystem
import SnapKit

class PriceUploadView: UIView {

    // MARK: - UI Components
    /// textContentView: Winey에서 사용될 커스텀 TextField인 WITextFieldView객체를 선언
    var textContentView = WITextFieldView(type: .upload_price)
    
    private var bag = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        textContentView.changeTextLength(9)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    /// configure: 텍스트 필드가 firstResponder가 될 지 말지를 결정하는 함수
    func configure(_ responder: Bool) {
        if responder {
            textContentView.become()
        } else {
            textContentView.resign()
        }
    }
    
    private func bind() {
        textContentView.pricePublisher
            .sink { _ in
                self.textContentView.makeActiveView()
            }
            .store(in: &bag)
        
        textContentView.textFieldDidEndEditingPublisher
            .sink {
                self.textContentView.makeInactiveView()
            }
            .store(in: &bag)
    }
    
    private func setLayout() {
        addSubviews(textContentView)
        
        textContentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
}
