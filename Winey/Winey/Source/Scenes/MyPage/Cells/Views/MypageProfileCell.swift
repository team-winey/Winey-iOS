//
//  ProfileView.swift
//  Winey
//
//  Created by 고영민 on 2023/07/12.
//

import UIKit

import SnapKit
import DesignSystem

final class MypageProfileCell: UICollectionViewCell {

    // MARK: - Properties

    static let identifier = MypageProfileCell.className
    
    // MARK: - UIComponents
    
    var levelContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_yellow
        containerView.layer.cornerRadius = 10
        return containerView
    }()
    
    var characterBackgroundView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_purple100
        containerView.layer.cornerRadius = 10
        return containerView
    }()
    
    let levelLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "LV. 기사",
            attributes: .init(
                style: .detail,
                weight: .medium,
                textColor: .winey_gray500
            )
        )
        return label
    }()
    
    let infoButton: UIButton = {
        let button = UIButton()
        button.setImage(.Mypage.info, for: .normal)
        return button
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.setText("부자될꺼임", attributes: .init(
            style: .headLine,
            weight: .bold,
            textColor: .winey_gray900
            )
        )
        return label
    }()
    
    var subtitleContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_gray900
        return containerView
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.setText(
            "\"헛둘 헛둘, 올라가보자!\"",
            attributes: .init(
                style: .detail,
                weight: .medium,
                textColor: .winey_gray0
                )
            )
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private var progressbarImageView: UIImageView = {
        let image = UIImageView()
        image.image = .Mypage.progressbar
        image.sizeToFit()
        return image
    }()
    
    func setUI() {
        contentView.backgroundColor = .white
    }
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SecondView Error!")
    }
    
    // MARK: - Layout
    
    func setLayout() {
        contentView.addSubviews(levelContainerView, nicknameLabel, subtitleContainerView,
                                progressbarImageView, infoButton, characterBackgroundView)
        contentView.backgroundColor = .white
        levelContainerView.addSubview(levelLabel)
        subtitleContainerView.addSubview(subtitleLabel)
        characterBackgroundView.addSubview(subtitleContainerView)
        
        characterBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(358)
            make.height.equalTo(196)
            make.center.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(52)
            make.top.equalToSuperview().inset(91)
            
            subtitleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(characterBackgroundView.snp.bottom).inset(13)
            }
            subtitleContainerView.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(subtitleLabel).inset(-8)
                make.verticalEdges.equalTo(subtitleLabel).inset(-2)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(characterBackgroundView.snp.bottom).inset(13)
            }
            levelContainerView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.leading.equalToSuperview().offset(23)
                
                levelLabel.snp.makeConstraints { make in
                    make.verticalEdges.equalToSuperview().inset(4)
                    make.horizontalEdges.equalToSuperview().inset(10)
                }
                
                infoButton.snp.makeConstraints { make in
                    make.leading.equalTo(levelContainerView.snp.trailing)
                    make.top.equalToSuperview().offset(12)
                }
                
                nicknameLabel.snp.makeConstraints { make in
                    make.leading.equalToSuperview().offset(23)
                    make.top.equalTo(levelLabel.snp.bottom).offset(8)
                }
                
                progressbarImageView.snp.makeConstraints { make in
                    make.top.equalTo(characterBackgroundView.snp.bottom).offset(13)
                    make.centerX.equalToSuperview()
                }
            }
        }
    }
}
