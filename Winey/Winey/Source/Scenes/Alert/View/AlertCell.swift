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
import Kingfisher


final class AlertCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = AlertCell.className
    
    // MARK: - UI Components
    
    private lazy var contralImageView: UIImageView = {
        let image = UIImageView()
        image.image = .Icon.winey
        return image
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .winey_gray50
        image.image = .Img.img_background
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
        contentView.addSubviews(backgroundImageView, contralImageView, categoryLabel, contentLabel, elapsedTimeLabel)
        backgroundImageView.addSubview(contralImageView)
        
        contralImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(backgroundImageView.snp.trailing).offset(10)
            $0.top.equalToSuperview().inset(16)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(4)
            $0.leading.equalTo(backgroundImageView.snp.trailing).offset(10)
        }
        elapsedTimeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - configure
    
    func configureCell(for model: Category) {
        categoryLabel.text = model.notiMessage
        
        //notiMessage
        if model.notiMessage.contains("평민") {
            contralImageView.image = UIImage.Img.commoner
        }
        else if model.notiMessage.contains("기사") {
            contralImageView.image = UIImage.Img.knight
        }
        else if model.notiMessage.contains("귀족") {
            contralImageView.image = UIImage.Img.noble
        }
        else if model.notiMessage.contains("황제") {
            contralImageView.image = UIImage.Img.emperor
        }
        
        //notiType
        else if model.notiType.contains("좋아요") {
            contralImageView.image = UIImage.Icon.like
        }
        else if model.notiType.contains("댓글") {
            contralImageView.image = UIImage.Icon.commentAlram
        }
        else if model.notiType.contains("위니 사용법") {
            contralImageView.image = UIImage.Icon.comment
        }
        else if model.notiType.contains("목표 달성 실패") {
            contralImageView.image = UIImage.Icon.winey
        }
    }
}
