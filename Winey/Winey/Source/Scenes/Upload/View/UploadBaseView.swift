//
//  UploadBaseView.swift
//  Winey
//
//  Created by 김응관 on 2023/07/11.
//

import UIKit

import DesignSystem
import SnapKit

class UploadBaseView: UIView {

    // MARK: - Properties
    
    var currentPage: Int = 0
    
    // MARK: - UI Components
    
    private let title: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 3, width: 174, height: 56))
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 66, width: 268, height: 20))
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Init func
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    func setUI() {
        backgroundColor = .clear
        
        switch currentPage {
        case 0:
            title.setText("절약을 실천한\n모습을 보여주세요!", attributes: Const.pageTitleAttributes)
            subTitle.setText("사진은 피드의 썸네일로 사용됩니다 :)",
                             attributes: Const.pageSubTitleAttributes)
        case 1:
            title.setText("절약 내용을\n작성해 주세요!", attributes: Const.pageTitleAttributes)
            subTitle.setText("적어주신 글은 썸네일과 함께 표시됩니다 :)",
                             attributes: Const.pageSubTitleAttributes)
        default:
            title.setText("얼마나\n절약했나요?", attributes: Const.pageTitleAttributes)
            subTitle.setText("절약하신 금액을 작성해주세요!", attributes: Const.pageSubTitleAttributes)
        }
    }
    
    private func setLayout() {
        addSubviews(title, subTitle)
        
        title.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        subTitle.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(7)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

}

private extension UploadBaseView {
    enum Const {
        static let pageTitleAttributes = Typography.Attributes(
            style: .headLine3,
            weight: .bold,
            textColor: .winey_gray900
        )
        
        static let pageSubTitleAttributes = Typography.Attributes(
            style: .detail2,
            weight: .medium,
            textColor: .winey_gray400
        )
    }
}
