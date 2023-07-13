//
//  GoalCollectionViewCell.swift
//  Winey
//
//  Created by 고영민 on 2023/07/12.
//

import UIKit
import SnapKit

final class GoalCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setStyle()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SecondView Error!")
    }
    
    // MARK: Component
    
    static let identifier = "GoalCollectionViewCell"
    
    var rectangleContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_gray200
        containerView.layer.cornerRadius = 10
        return containerView
    }()
    
    var goalLabel: UILabel = {
        let label = UILabel()
        label.text = "절약 목표"
        label.font = .detail_m13
        label.textColor = .winey_gray900
        label.sizeToFit()
        return label
    }()
    
    var goalShowingLabel: UILabel = {
        let label = UILabel()
        label.text = "10,000원"
        label.font = .head_b18
        label.textColor = .winey_gray900
        label.sizeToFit()
        return label
    }()
    
    lazy var modifyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.winey_gray200
        button.clipsToBounds = true
        button.setImage(UIImage(named: "ic_pen"), for: .normal)
        return button
    }()
    
    var temp1Label: UILabel = {
        let label = UILabel()
        label.font = .detail_m13
        label.textColor = .winey_gray600
        label.text = "절약기간"
        label.textAlignment = .center
        return label
    }()
    
    var temp1_ShowingLabel: UILabel = {
        let label = UILabel()
        label.font = .head_b18
        label.textColor = .winey_gray900
        label.text = "D-18"
        label.textAlignment = .center
        return label
    }()
    
    var temp2Label: UILabel = {
        let label = UILabel()
        label.font = .detail_m13
        label.textColor = .winey_gray600
        label.text = "누적위니"
        label.textAlignment = .center
        return label
    }()
    
    var temp2_ShowingLabel: UILabel = {
        let label = UILabel()
        label.font = .head_b18
        label.textColor = .winey_gray900
        label.textAlignment = .center
        label.text = "50,000원"
        return label
    }()
    
    var temp3Label: UILabel = {
        let label = UILabel()
        label.font = .detail_m13
        label.textColor = .winey_gray600
        label.textAlignment = .center
        label.text = "위니횟수"
        return label
    }()
    
    var temp3_ShowingLabel: UILabel = {
        let label = UILabel()
        label.font = .head_b18
        label.textColor = .winey_gray900
        label.textAlignment = .center
        label.text = "80번"
        return label
    }()
    
    func setStyle() {
        contentView.backgroundColor = .white
    }
    
    // MARK: Layout
    
    func setLayout() {
        contentView.addSubviews(rectangleContainerView, temp1Label, temp1_ShowingLabel, temp2Label, temp2_ShowingLabel, temp3Label, temp3_ShowingLabel)
        
        rectangleContainerView.addSubviews(goalLabel, goalShowingLabel, modifyButton)
        
        
        
        
        goalLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(22)
        }
        
        goalShowingLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(22)
        }
        
        modifyButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        rectangleContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(18)
            make.width.equalTo(358)
            make.height.equalTo(69)
        }
        
        temp1Label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(47)
            make.top.equalToSuperview().inset(107)
        }
        
        temp1_ShowingLabel.snp.makeConstraints { make in //
            make.leading.equalToSuperview().inset(48)
            make.bottom.equalToSuperview().inset(18)
        }
        
        temp2Label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(107)
        }
        
        temp2_ShowingLabel.snp.makeConstraints { make in //
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(18)
        }
        
        temp3Label.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(47)
            make.top.equalToSuperview().inset(107)
        }
        
        temp3_ShowingLabel.snp.makeConstraints { make in //
            make.trailing.equalToSuperview().inset(48)
            make.bottom.equalToSuperview().inset(18)
        }
    }
}
