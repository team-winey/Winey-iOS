//
//  LimitedPickerViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/08/27.
//

import UIKit

import DesignSystem
import SnapKit
import PhotosUI

class LimitedPickerViewController: UIViewController {
    
    // MARK: - Properties
    
    var fetchResult = PHFetchResult<PHAsset>()
    
    var authorizedPhotos = [UIImage]()
    var photoSizes = [CGSize]()
    let imageSpace: CGFloat = 2
    let scale = UIScreen.main.scale
    
    var thumbnailSize: CGSize {
        return CGSize(width: ((UIScreen.main.bounds.width) - (imageSpace * 3)) / 4,
                      height: ((UIScreen.main.bounds.width) - (imageSpace * 3)) / 4)
    }
        
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PHPhotoLibrary.shared().register(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupCollectionView()
        setAddTarget()
        setLayout()
    }
    
    // MARK: - UI Components
    
    private let navigationBar = WINavigationBar(leftBarItem: .close)
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.itemSize = thumbnailSize
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        view.register(LimitedPickerCollectionViewCell.self, forCellWithReuseIdentifier: LimitedPickerCollectionViewCell.className)
        view.showsVerticalScrollIndicator = true
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = self.view.center
        activityIndicator.color = .winey_gray600
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        
        activityIndicator.stopAnimating()
        return activityIndicator
    }()

//    private lazy var morePhotoAlert: UIAlertController = {
//        let alert = UIAlertController(title: "Winey가 갤러리에 접근하려고 합니다",
//                            message: "접근 권한 허용",
//                                      preferredStyle: UIAlertController.Style.alert)
//
//        alert.overrideUserInterfaceStyle = .dark
//
//        let allowAction = UIAlertAction(title: "권한 설정 변경하기", style: .default) { (action) in
//
//            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                return
//            }
//
//            if UIApplication.shared.canOpenURL(settingsUrl) {
//                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                    print("Settings opened: \(success)")
//                })
//            }
//        }
//
//        let addAction = UIAlertAction(title: "더 많은 사진 선택", style: .default) { (action) in
//            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self) { _ in
//                DispatchQueue.main.async {
//                    self.navigationController?.pushViewController(ImageLoadingViewController(), animated: false)
//                    DispatchQueue.global(qos: .background).async {
//                        self.getCanAccessImages()
//                    }
//                }
//            }
//        }
//
//        let cancelAction = UIAlertAction(title: "현재 상태 유지", style: .default) { (action) in
//            self.collectionView.reloadData()
//        }
//
//        alert.addAction(allowAction)
//        alert.addAction(addAction)
//        alert.addAction(cancelAction)
//
//        return alert
//    }()
    
    // MARK: - Methods
    
    func setUI() {
        view.backgroundColor = .winey_gray0
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setAddTarget() {
        // navigationBar.rightButton.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        navigationBar.leftButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
//    @objc
//    func addButtonDidTap() {
//        self.requestPHPhotoLibraryAuthorization {
//            DispatchQueue.main.async {
//                self.present(self.morePhotoAlert, animated: true)
//            }
//        }
//    }
    
    @objc
    func cancelButtonDidTap() {
        // self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func configure(_ img: [UIImage], _ size: [CGSize]) {
        authorizedPhotos = img
        photoSizes = size
    }
    
    func setLayout() {
        view.addSubviews(navigationBar, collectionView, activityIndicator)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
//    func getCanAccessImages() {
//        self.photoSizes = []
//        self.authorizedPhotos = []
//
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.deliveryMode = .fastFormat
//        requestOptions.isNetworkAccessAllowed = true
//        requestOptions.isSynchronous = true
//        requestOptions.resizeMode = .exact
//
//        let fetchOptions = PHFetchOptions()
//        self.fetchResult = PHAsset.fetchAssets(with: fetchOptions)
//
//        self.fetchResult.enumerateObjects { (asset, _, _) in
//            PHImageManager().requestImage(for: asset,
//                                          targetSize: self.thumbnailSize,
//                                          contentMode: .aspectFill,
//                                          options: requestOptions) { (image, info) in
//
//                guard let image = image else { return }
//                self.authorizedPhotos.append(image)
//                self.photoSizes.append(image.size)
//            }
//        }
//        NotificationCenter.default.post(name: .imgLoadingEnd, object: nil)
//    }
}

extension LimitedPickerViewController: PHPhotoLibraryChangeObserver {
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

//    func requestPHPhotoLibraryAuthorization(completion: @escaping () -> Void) {
//        PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
//            switch status {
//            case .limited:
//                PHPhotoLibrary.shared().register(self)
//                completion()
//            case .authorized:
//                completion()
//            default:
//                break
//            }
//        }
//    }
}

extension LimitedPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.authorizedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LimitedPickerCollectionViewCell.className, for: indexPath) as! LimitedPickerCollectionViewCell
        cell.configureCell(image: authorizedPhotos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let width = photoSizes[indexPath.item].width - 32 / scale
        let height = photoSizes[indexPath.item].height - 32 / scale
        let targetImage = authorizedPhotos[indexPath.item].resizing(width: width, height: height)

        NotificationCenter.default.post(name: .whenImgSelected, object: nil, userInfo: ["img": targetImage])
        self.navigationController?.popToRootViewController(animated: true)
    }
}
