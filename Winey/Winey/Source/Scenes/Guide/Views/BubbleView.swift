//
//  BubbleView.swift
//  Winey
//
//  Created by 고영민 on 2023/07/15.
//

import UIKit

import SnapKit
import DesignSystem

final class BubbleView: UIView {

    // MARK: - UI Components
    
    private let bubbleImageView: UIImageView = {
        let image = UIImageView()
        image.image = .Img.bubble
        image.sizeToFit()
        return image
    }()
    
    private let bubbleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.setText(
            "캐릭터를 레벨업해 \n더 즐겁게 위니를 사용해보세요!",
            attributes: .init(
                style: .body,
                weight: .medium,
                textColor: .winey_gray500
            )
        )
        return label
    }()
    
    // MARK: - View Life Cycles

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("SecondView Error!")
    }
    
    // MARK: - UI & Layout
    
    func setLayout() {
        self.addSubview(bubbleImageView)
        bubbleImageView.addSubview(bubbleLabel)
        
        bubbleLabel.snp.makeConstraints { make in
            make.top.equalTo(bubbleImageView).inset(11)
            make.leading.equalTo(bubbleImageView).inset(24)
        }
        
        bubbleImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(29)
            make.top.equalToSuperview().inset(18)
        }
    }
}
