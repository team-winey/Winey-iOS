//
//  GalleryViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/08/30.
//

import UIKit

import DesignSystem
import SnapKit
import Photos

class GalleryViewController: UIViewController {
    
    var fetchResult = PHFetchResult<PHAsset>()
    var authorizedPhotos = [UIImage]()
    var photoSizes = [CGSize]()
    let imageSpace: CGFloat = 2
    
    var thumbnailSize: CGSize {
        return CGSize(width: ((UIScreen.main.bounds.width) - (imageSpace * 3)) / 4,
                      height: ((UIScreen.main.bounds.width) - (imageSpace * 3)) / 4)
    }
    
    var viewController = LimitedPickerViewController()
    
    private lazy var morePhotoAlert: UIAlertController = {
        let alert = UIAlertController(title: "Winey가 갤러리에 접근하려고 합니다",
                            message: "접근 권한 허용",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.overrideUserInterfaceStyle = .dark

        let allowAction = UIAlertAction(title: "권한 설정 변경하기", style: .default) { (action) in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }

        let addAction = UIAlertAction(title: "더 많은 사진 선택", style: .default) { (action) in
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self) { _ in
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(ImageLoadingViewController(), animated: false)
                    DispatchQueue.global(qos: .background).async {
                        self.getCanAccessImages()
                    }
                }
            }
        }

        let cancelAction = UIAlertAction(title: "현재 상태 유지", style: .default) { (action) in
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(ImageLoadingViewController(), animated: false)
                DispatchQueue.global(qos: .background).async {
                    self.getCanAccessImages()
                }
            }
        }

        alert.addAction(allowAction)
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        return alert
    }()
    
    private lazy var btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("접근 권한 허용된 사진", for: .normal)
        btn.setImage(UIImage.checkmark, for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(gotoAlbum), for: .touchUpInside)
        return btn
    }()
    
    private let navigationBar = WINavigationBar(leftBarItem: .close, title: "갤러리")

    @objc
    func cancelButtonDidTap() {
        self.navigationController?.popToRootViewController(animated: true)
        // self.dismiss(animated: true)
    }
    
//    @objc
//    func addButtonDidTap() {
//        self.requestPHPhotoLibraryAuthorization {
//            DispatchQueue.main.async {
//                self.present(self.morePhotoAlert, animated: true)
//            }
//        }
//    }
    
    func setAddTarget() {
        navigationBar.leftButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        // navigationBar.rightButton.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    }
    
    func setLayout() {
        view.addSubviews(navigationBar, btn)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        btn.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func setUI() {
        view.backgroundColor = .winey_gray0
    }
    
    func getCanAccessImages() {
        self.photoSizes = []
        self.authorizedPhotos = []
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .fastFormat
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = true
        requestOptions.resizeMode = .exact
        
        let fetchOptions = PHFetchOptions()
        self.fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        self.fetchResult.enumerateObjects { (asset, _, _) in
            PHImageManager().requestImage(for: asset,
                                          targetSize: self.thumbnailSize,
                                          contentMode: .aspectFill,
                                          options: requestOptions) { (image, info) in
                
                guard let image = image else { return }
                self.authorizedPhotos.append(image)
                self.photoSizes.append(image.size)
            }
        }
        NotificationCenter.default.post(name: .imgLoadingEnd, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setAddTarget()
    }
    
    func configure(_ img: [UIImage], _ size: [CGSize]) {
        authorizedPhotos = img
        photoSizes = size
    }
    
    @objc
    func gotoAlbum() {
        let vc = LimitedPickerViewController()
        vc.configure(authorizedPhotos, photoSizes)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension GalleryViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.authorizedPhotos = []
        guard let details = changeInstance.changeDetails(for: self.fetchResult) else { return }
        self.update(changes: details.fetchResultAfterChanges)
    }

    func update(changes: PHFetchResult<PHAsset>) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        changes.enumerateObjects { (asset, _, _) in
            PHImageManager().requestImage(for: asset, targetSize: self.thumbnailSize, contentMode: .aspectFill, options: requestOptions) { (image, info) in
                guard let image = image else { return }
                self.authorizedPhotos.append(image)
                self.photoSizes.append(image.size)
            }
        }
    }
}
