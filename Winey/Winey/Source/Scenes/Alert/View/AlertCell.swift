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
        label.setText("알림항목(default)",
                      attributes: .init(
                        style: .detail,
                        weight: .medium,
                        textColor: .winey_gray400)
        )
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.setText("알림내용(default)",
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
        label.setText("몇 분 전(default)",
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
            switch model.notiType {
            case "HOWTOLEVELUP":
                categoryLabel.text = "위니 사용법"
            case "COMMENTNOTI":
                categoryLabel.text = "댓글"
            case "LIKENOTI":
                categoryLabel.text = "좋아요"
            case "RANKUPTO2", "RANKUPTO3", "RANKUPTO4":
                categoryLabel.text = "등급 상승"
            case "DELETERANKDOWNTO1", "DELETERANKDOWNTO2", "DELETERANKDOWNTO3":
                categoryLabel.text = "등급 하락"
            case "GOALFAILED":
                categoryLabel.text = "목표달성 실패"
                
            default:
                categoryLabel.text = model.notiType
            }
            
            contentLabel.text = model.notiMessage
            elapsedTimeLabel.text = model.timeAgo
            
            // 예외처리1) 닉네임에 '계급명'이 들어간 유저를 고려한 예외상황. ex) 귀족영민님이 회원님의 게시글을 좋아합니다.
            // notiType에 따른 이미지 지정을 앞에,
            // notiMessage에 따른 이미지 지정을 뒤에 둠으로써 예외처리1을 해결하였습니다.
            
            //notiType
            if model.notiType.contains("LIKENOTI") {
                contralImageView.image = UIImage.Icon.like
            }
            else if model.notiType.contains("COMMENTNOTI") {
                contralImageView.image = UIImage.Icon.commentAlram
            }
            else if model.notiType.contains("HOWTOLEVELUP") {
                contralImageView.image = UIImage.Icon.winey
            }
            else if model.notiType.contains("GOALFAILED") {
                contralImageView.image = UIImage.Icon.winey
            }
            
            //notiMessage
            else if model.notiMessage.contains("평민") {
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
        }
    }
