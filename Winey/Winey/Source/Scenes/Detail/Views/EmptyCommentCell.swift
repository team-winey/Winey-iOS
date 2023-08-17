//
//  EmptyCommentCell.swift
//  Winey
//
//  Created by Woody Lee on 2023/08/14.
//

import Combine
import UIKit

import DesignSystem
import SnapKit

final class EmptyCommentCell: UITableViewCell {
    private let emptyImageView = UIImageView()
    private let emptyLabel = UILabel()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAttribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmptyCommentCell {
    func setupAttribute() {
        self.emptyImageView.image = .Icon.empty_comment
        self.backgroundColor = .winey_gray100
        self.emptyLabel.setText(
            "아직 댓글이 없어요",
            attributes: .init(
                style: .body,
                weight: .medium,
                textColor: .winey_gray400
            )
        )
    }
    
    func setupLayout() {
        self.contentView.addSubviews(emptyImageView, emptyLabel)
        emptyImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(46)
            make.height.equalTo(44)
        }
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(65)
        }
    }
}
