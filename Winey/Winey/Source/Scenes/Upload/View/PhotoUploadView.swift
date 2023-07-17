//
//  PhotoUploadView.swift
//  Winey
//
//  Created by 김응관 on 2023/07/11.
//

import UIKit

import DesignSystem
import SnapKit

class PhotoUploadView: UIView {
    
    // MARK: - Properties
    
    // 선택된 이미지객체를 ViewController로 전달하기 위해 사용되는 클로저
    var imageSendClousre: ((_ data: UIImage?) -> Void)?
    
    var targetImage: UIImage? {
        didSet {
            if targetImage != nil {
                galleryBtn.isHidden = true
                imgBackground.isHidden = true
                photoBtn.isHidden = false
            } else {
                photoBtn.isHidden = true
                galleryBtn.isHidden = false
                imgBackground.isHidden = false
            }
        }
    }
    
    // MARK: - UI Components
    
    lazy var galleryBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.backgroundColor = .winey_purple400
        return btn
    }()
    
    lazy var photoBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    private var guideText: UILabel = {
        let label = UILabel(frame: CGRect(x: 18, y: 18, width: 160, height: 34))
        label.numberOfLines = 0
        label.setText("절약을 인증할 수 있는\n사진을 업로드해 주세요.",
                      attributes: Typography.Attributes(style: .body,
                                                        weight: .medium,
                                                        textColor: .winey_gray0))
        return label
    }()
    
    private let imgBackground: UIView = {
        let square = UIView()
        square.makeCornerRound(radius: 5)
        square.backgroundColor = .winey_purple300
        return square
    }()
    
    private let img: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "upload_photo")
        return img
    }()
    
    // MARK: - Methods
    
    func configure(_ img: UIImage) {
        targetImage = img
        photoBtn.setImage(targetImage?.resizing(width: self.frame.width, height: self.frame.height), for: .normal)
    }
    
    func setLayout() {
        addSubviews(galleryBtn, photoBtn, imgBackground)
        galleryBtn.addSubview(guideText)
        imgBackground.addSubview(img)
        
        galleryBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        photoBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        guideText.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(18)
        }
        
        imgBackground.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(18)
            $0.size.equalTo(42)
        }
        
        img.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(7)
        }
    }
    
    // MARK: - Init function
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
