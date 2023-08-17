//
//  MIPopupViewController.swift
//  
//
//  Created by Woody Lee on 2023/07/14.
//

import UIKit

import SnapKit

public final class MIPopupViewController: UIViewController {
    public typealias Action = (() -> Void)
    private let backgroundButton = UIButton()
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let buttonContainerStackView = UIStackView()
    
    private let content: MIPopupContent
    private var actions: [Action?] = []
    
    public init(content: MIPopupContent) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    public func addButton(title: String, type: MIButtonType, tapButtonHandler: Action?) {
        let button = MIButton(type: type)
        let title = Typography.build(string: title, attributes: type.titleAttributes)
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        actions.append(tapButtonHandler)
        buttonContainerStackView.addArrangedSubview(button)
    }
    
    @objc private func tapButton(_ sender: MIButton) {
        guard let index = buttonContainerStackView.subviews.firstIndex(of: sender) else { return }
        guard actions.count > index else { return }
        self.dismiss(animated: true) { [weak self] in
            self?.actions[index]?()
        }
    }
    
    @objc private func tapBackgroundButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    private func setUI() {
        view.backgroundColor = .winey_gray900.withAlphaComponent(0.4)
        containerView.backgroundColor = .winey_gray0
        containerView.layer.cornerRadius = 12
        buttonContainerStackView.axis = .horizontal
        buttonContainerStackView.spacing = 4
        buttonContainerStackView.alignment = .fill
        buttonContainerStackView.distribution = .fillEqually
        titleLabel.setText(content.title, attributes: Const.titleAttributes)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        subtitleLabel.setText(content.subtitle, attributes: Const.subtitleAttributes)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.isHidden = content.subtitle == nil
        backgroundButton.addTarget(self, action: #selector(tapBackgroundButton), for: .touchUpInside)
    }
    
    private func setLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        view.addSubview(backgroundButton)
        view.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(stackView)
        containerView.addSubview(buttonContainerStackView)
        
        backgroundButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(280)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(17)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        buttonContainerStackView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(21)
            make.horizontalEdges.equalToSuperview().inset(13)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
    }
    
    private enum Const {
        static let titleAttributes = Typography.Attributes(
            style: .headLine4,
            weight: .bold,
            textColor: .winey_gray900
        )
        static let subtitleAttributes = Typography.Attributes(
            style: .detail,
            weight: .medium,
            textColor: .winey_gray500
        )
    }
}
