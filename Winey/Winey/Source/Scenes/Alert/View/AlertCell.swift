//
//  AlertCell.swift
//  Winey
//
//  Created by 고영민 on 2023/08/05.
//

import UIKit
import SnapKit
import Moya
import DesignSystem

final class AlertCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = AlertCell.className
    
    // MARK: - UI Components
    
    private lazy var contralImage: UIImageView = {
        let image = UIImageView()
        image.image = .Icon.next
        return image
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.setText("좋아요",
                      attributes: .init(
                        style: .detail,
                        weight: .medium,
                        textColor: .winey_gray400)
        )
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.setText("님이 회원님의 게시물을 좋아해요",
                      attributes: .init(
                        style: .detail,
                        weight: .medium,
                        textColor: .winey_gray900
                      )
        )
        return label
    }()
    
    private let elapsedTimeLabel: UILabel = {
        let label = UILabel()
        label.setText("10분전",
                      attributes: .init(
                        style: .detail,
                        weight: .medium,
                        textColor: .winey_gray400)
        )
        return label
    }()
    
    
    // MARK: - View Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI
    
    private func setUI() {
        separatorInset.left = 0
        selectionStyle = .none
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        contentView.backgroundColor = .winey_gray0
        contentView.addSubviews(contralImage, categoryLabel, contentLabel, elapsedTimeLabel)
        
        contralImage.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(contralImage.snp.trailing).offset(10)
            $0.top.equalToSuperview().inset(16)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).inset(4)
            $0.leading.equalTo(contralImage.snp.trailing).offset(10)
        }
        elapsedTimeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - configure
    
    func configure() {
    }
}
