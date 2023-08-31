//
//  LimitedPickerCollectionViewCell.swift
//  Winey
//
//  Created by 김응관 on 2023/08/28.
//

import UIKit

import SnapKit

class LimitedPickerCollectionViewCell: UICollectionViewCell {
        
    // MARK: - UI Properties
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LimitedPickerCollectionViewCell {
    
    // MARK: - Layout
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Method
    
    func configureCell(image: UIImage) {
        imageView.image = image
    }
}
