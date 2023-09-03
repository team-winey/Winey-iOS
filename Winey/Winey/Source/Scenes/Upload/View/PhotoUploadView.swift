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
    
    /// targetImage
    /// 갤러리에서 선택된 이미지가 저장되면서 이미지가 채워진 버튼이 나타날지, 이미지가 채워지지 않은 초기 형태의 버튼이 나타날지 결정해 줌
    private var targetImage: UIImage? {
        didSet {
            if targetImage != nil {
                galleryBtn.isHidden = true
                photoBtn.isHidden = false
            } else {
                photoBtn.isHidden = true
                galleryBtn.isHidden = false
            }
        }
    }
    
    // MARK: - UI Components
    
    /// galleryBtn: 이미지가 불러와지지 않았을경우에 보여지는 보라색 배경의 버튼
    /// photoBtn: 이미지가 불러와졌을때, 해당 이미지를 배경으로 가진채 보여지는 버튼
    /// guideText: galleryBtn안에 들어갈 사진 업로드 안내문구
    /// imgbackground: galleryBtn 우측 하단에 들어갈 연보라색 사각형
    /// img: imgbackground안에 들어갈 upload_photo 이미지뷰
    ///
    
    let layerView = DotLayerView()

    lazy var galleryBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.backgroundColor = .winey_purple100
        return btn
    }()
    
    lazy var photoBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
    
    private let guideText: UILabel = {
        let label = UILabel(frame: CGRect(x: 92, y: 93, width: 173, height: 37))
        label.numberOfLines = 0
        label.setText("절약을 인증할 수 있는\n사진을 업로드해 주세요.",
                      attributes: Typography.Attributes(style: .body,
                                                        weight: .medium,
                                                        textColor: .winey_purple400))
        label.textAlignment = .center
        return label
    }()
    
    private let plusImg: UIImageView = {
        let plusImg = UIImageView(frame: CGRect(x: 153, y: 86.5, width: 36, height: 36))
        plusImg.image = .Btn.btn_plus
        return plusImg
    }()
    
    // MARK: - Methods
    
    /// configure: UploadViewController로부터 전달받은 UIImage 데이터를 바탕으로 photoBtn의 배경 이미지를 세팅해주는 함수
    /// 이미지가 targetImage에 들어가면서, tagetImage의 didSet 옵저버가 작동하면서 자동으로 galleryBtn이 hidden, photoBtn이 !ishidden 됨
    func configure(_ img: UIImage) {
        targetImage = img
        photoBtn.setImage(targetImage?.resizeWithWidth(width: self.frame.width), for: .normal)
    }
    
    private func setLayout() {
        addSubviews(layerView, photoBtn)
        layerView.addSubview(galleryBtn)
        galleryBtn.addSubviews(plusImg, guideText)
        
        galleryBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        photoBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        layerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(1)
        }
        
        plusImg.snp.makeConstraints {
            $0.top.equalToSuperview().inset(86.5)
            $0.centerX.equalToSuperview()
        }
        
        guideText.snp.makeConstraints {
            $0.top.equalTo(plusImg.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
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
