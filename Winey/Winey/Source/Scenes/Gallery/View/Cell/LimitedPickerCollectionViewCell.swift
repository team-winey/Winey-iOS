//
//  LimitedPickerCollectionViewCell.swift
//  Winey
//
//  Created by 김응관 on 2023/08/31.
//

import UIKit

import SnapKit

class LimitedPickerCollectionViewCell: UICollectionViewCell {
        
    // MARK: - UI Properties
    
    var representedAssetIdentifier: String?
    var thumbnailImage: UIImage = UIImage() {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    var originalSize: CGSize = CGSize() 
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LimitedPickerCollectionViewCell {
    
    // MARK: - Layout
    
    private func setLayout() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Method
    
    func getImage() -> UIImage {
        return imageView.image ?? UIImage()
    }
}
