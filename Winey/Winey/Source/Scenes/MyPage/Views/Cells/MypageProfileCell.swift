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
    
    var infoButtonTappedClosure: (() -> Void)?
    var nextButtonTappedClosure: (() -> Void)?
    
    static let identifier = MypageProfileCell.className
    
    // MARK: - UIComponents
    
    private var levelContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.winey_yellow
        containerView.layer.cornerRadius = 12
        return containerView
    }()
    
    private var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let levelLabel: UILabel = {
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
    
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setImage(.Icon.info, for: .normal)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.clipsToBounds = true
        button.setImage(.Icon.next, for: .normal)
        return button
    }()
    
    private let nicknameLabel: UILabel = {
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
        image.image = .Icon.progressbar
        image.sizeToFit()
        return image
    }()
    
    private func setUI() {
        contentView.backgroundColor = .white
    }
    
    @objc
    private func infoButtonTapped() {
        self.infoButtonTappedClosure?()
    }
    
    @objc
    private func nextButtonTapped() {
        self.nextButtonTappedClosure?()
    }
    
    // MARK: - View Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        setUI()
        setAddTarget()
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
        contentView.backgroundColor = .white
        contentView.addSubviews(levelContainerView, nicknameLabel)
        contentView.addSubviews(progressbarImageView, infoButton, characterImageView)
        contentView.addSubviews(progressbarImageView, infoButton, characterImageView, nextButton)
        
        levelContainerView.addSubview(levelLabel)
        
        levelContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(23)
            
            levelLabel.snp.makeConstraints { make in
                make.verticalEdges.equalToSuperview().inset(4)
                make.horizontalEdges.equalToSuperview().inset(10)
            }
        }
        
        infoButton.snp.makeConstraints { make in
            make.leading.equalTo(levelContainerView.snp.trailing)
            make.top.bottom.equalTo(levelContainerView)
        }
        
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(characterImageView.snp.top)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(23)
            make.top.equalTo(levelContainerView.snp.bottom).offset(8)
        }
        
        characterImageView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(91)
        }
        progressbarImageView.snp.makeConstraints { make in
            make.top.equalTo(characterImageView.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
    }
    
    func setAddTarget() {
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
}
