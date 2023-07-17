//
//  PhotoUploadCell.swift
//  Winey
//
//  Created by 김응관 on 2023/07/12.
//

import UIKit

import SnapKit

class PhotoUploadCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var page: Int = 0
    
    // MARK: - UI Components
    
    private lazy var titleView: UploadBaseView = UploadBaseView()
    private lazy var photoView: PhotoUploadView = PhotoUploadView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(_ index: Int) {
        titleView.currentPage = index
        page = index
    }
    
    func setLayout() {
        
//        contentView.addSubview(titleView)
//
//        titleView.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.horizontalEdges.equalToSuperview().inset(17)
//            $0.height.equalTo(86)
//        }
        
        switch page {
        default:
            contentView.addSubview(photoView)
            
            photoView.snp.makeConstraints {
                $0.top.equalTo(titleView.snp.bottom)
                $0.horizontalEdges.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(182)
            }
        }
    }
}
