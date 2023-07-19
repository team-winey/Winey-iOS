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

    struct ViewModel {
        let nickname : String
        let level : UserLevel
    }
    
    // MARK: - Properties

    static let identifier = MypageProfileCell.className
    
    // MARK: - UIComponents
    
    var levelContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_yellow
        containerView.layer.cornerRadius = 12
        return containerView
    }()
    
    var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        return imageView
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
    
    func configure(model: ViewModel) {
        levelLabel.setText(
            "LV. \(model.level.rawValue)",
            attributes: .init(
                style: .detail2,
                weight: .medium,
                textColor: .winey_gray900
            )
        )
        nicknameLabel.setText(
            "\(model.nickname)",
            attributes: .init(
                style: .headLine,
                weight: .bold,
                textColor: .winey_gray900
            )
        )
        characterImageView.image = model.level.characterImage
        progressbarImageView.image = model.level.progressbarImage
    }
    
    // MARK: - Layout
    
    func setLayout() {
        contentView.addSubviews(levelContainerView, nicknameLabel)
        contentView.addSubviews(progressbarImageView, infoButton, characterImageView)
        contentView.backgroundColor = .white
        levelContainerView.addSubview(levelLabel)
        
        characterImageView.snp.makeConstraints { make in
            make.width.equalTo(358)
            make.height.equalTo(196)
            make.center.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(52)
            make.top.equalToSuperview().inset(91)
            
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
                    make.top.equalTo(levelContainerView.snp.bottom).offset(8)
                }
                
                progressbarImageView.snp.makeConstraints { make in
                    make.top.equalTo(characterImageView.snp.bottom).offset(13)
                    make.centerX.equalToSuperview()
                }
            }
        }
    }
}
