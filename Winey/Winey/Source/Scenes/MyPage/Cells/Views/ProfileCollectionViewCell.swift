//
//  ProfileView.swift
//  Winey
//
//  Created by 고영민 on 2023/07/12.
//

import UIKit
import SnapKit

final class ProfileCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SecondView Error!")
    }
    
    // MARK: Component
    
    static let identifier = "ProfileCollectionViewCell"
    
    var levelContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_yellow
        containerView.layer.cornerRadius = 10
        return containerView
    }()
    
    let levelLabel: UILabel = {
        let label = UILabel()
        label.text = "LV.기사"
        label.font = .detail_m12
        label.textColor = UIColor.winey_gray900
        label.clipsToBounds = true
        return label
    }()
    
    let infoButton: UIButton = {
        let button = UIButton()
        // TODO: 이미지 삽입
        button.setImage(UIImage(named: "Group 1171275812"), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 4
        return button
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "부자될꺼임"
        label.textColor = UIColor.winey_gray900
        label.font = .head_b28
        return label
    }()
    
    var characterImage: UIImageView = {
        let image = UIImageView()
        // TODO: 이미지 삽입
        image.image = UIImage(named: "Rectangle 6667428")
        image.sizeToFit()
        return image
    }()
    
    var subtitleContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_gray900
        return containerView
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "\"헛둘 헛둘, 올라가보자!\""
        label.textAlignment = .center
        label.font = .detail_m13
        label.textColor = .white
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private var progressbarImage: UIImageView = {
        let image = UIImageView()
        // TODO: 이미지 삽입
        image.image = UIImage(named: "level_progressbar_i")
        image.sizeToFit()
        return image
    }()
    
    // MARK: Layout
    
    func setLayout() {
        
        contentView.addSubviews(levelContainerView, infoButton, nicknameLabel, characterImage, subtitleContainerView, progressbarImage)
        contentView.backgroundColor = .white
        levelContainerView.addSubview(levelLabel)
        subtitleContainerView.addSubview(subtitleLabel)
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(characterImage.snp.bottom).inset(13)
        }
        subtitleContainerView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(subtitleLabel).inset(-8)
            make.verticalEdges.equalTo(subtitleLabel).inset(-2)
        }
        subtitleContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(65)
            make.top.equalToSuperview().inset(250)
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
            
            characterImage.snp.makeConstraints { make in
                make.top.equalTo(nicknameLabel.snp.bottom).offset(16)
                make.leading.equalToSuperview().offset(16)
            }
            
            progressbarImage.snp.makeConstraints { make in
                make.top.equalTo(characterImage.snp.bottom).offset(13)
                make.leading.equalToSuperview().offset(26)
            }
        }
    }
}
