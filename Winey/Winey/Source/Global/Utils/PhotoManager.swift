//
//  PhotoViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/08/28.
//

import UIKit

import DesignSystem
import PhotosUI
import Photos

protocol PhotoManaging: AnyObject {
    func pickImage()
    func deniedAlert()
    func openTotalGallery()
    func openLimitedGallery()
}

class PhotoManager: UIViewController {
    
    static let shared = PhotoManager()
    
    weak var photoDelegate: PhotoManaging?
    var selectedImage : UIImage?
    
    let scale = UIScreen.main.scale
    
    var fetchResult = PHFetchResult<PHAsset>()
    var authorizedPhotos = [UIImage]()
    var photoSizes = [CGSize]()
//    var thumbnailSize: CGSize {
//        return CGSize(width: (UIScreen.main.bounds.width / 3) * scale, height: 100 * scale)
//    }
    
    var thumbnailSize: CGSize {
        return CGSize(width: ((UIScreen.main.bounds.width) - (2 * 3)) / 4,
                      height: ((UIScreen.main.bounds.width) - (2 * 3)) / 4)
    }
    
    lazy var photoPicker: PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let imgPicker = PHPickerViewController(configuration: config)
        imgPicker.delegate = self
        
        return imgPicker
    }()
    
    lazy var alertController: UIAlertController = {
        let alert = UIAlertController(title: "권한 거부됨",
                            message: "갤러리 접근이 거부 되었습니다. 피드 작성이 불가합니다",
                            preferredStyle: UIAlertController.Style.alert)
        
        alert.overrideUserInterfaceStyle = .dark
        
        let allowAction = UIAlertAction(title: "권한 설정으로 이동하기", style: .default) { (action) in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alertController.addAction(allowAction)
        alertController.addAction(cancelAction)
        
        return alert
    }()

    
    func getCanAccessImages() -> ([UIImage], [CGSize]) {
        // PHPhotoLibrary.shared().register(self)
        photoSizes = []
        authorizedPhotos = []
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = true
        
        let fetchOptions = PHFetchOptions()
        fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        fetchResult.enumerateObjects { (asset, _, _) in
            PHImageManager().requestImage(for: asset, targetSize: self.thumbnailSize, contentMode: .aspectFill, options: requestOptions) { (image, info) in
                guard let image = image else { return }
                
                let render = UIGraphicsImageRenderer(size: image.size)
                let renderImage = render.image { context in
                    image.draw(in: CGRect(origin: .zero, size: image.size))
                }
                
                self.authorizedPhotos.append(renderImage)
                self.photoSizes.append(renderImage.size)
            }
        
        NotificationCenter.default.post(name: .imgLoadingEnd, object: nil)
        }
        
        return (authorizedPhotos, photoSizes)
    }
    
    func setGalleryAuth() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
            switch status {
            case .denied:
                DispatchQueue.main.async {
                    self.photoDelegate?.deniedAlert()
                }
            case .authorized:
                DispatchQueue.main.async {
                    self.photoDelegate?.openTotalGallery()
                }
            case .limited:
                DispatchQueue.main.async {
                    self.photoDelegate?.openLimitedGallery()
                }
            case .notDetermined, .restricted:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { (state) in
                    switch state {
                    case .authorized:
                        DispatchQueue.main.async {
                            self.photoDelegate?.openTotalGallery()
                        }
                    case .limited:
                        DispatchQueue.main.async {
                            self.photoDelegate?.openLimitedGallery()
                        }
                    case .notDetermined, .restricted:
                        DispatchQueue.main.async {
                            self.photoDelegate?.deniedAlert()
                        }
                    default:
                        break
                    }
                }
            default:
                break
            }
        }
    }
    
    
}

extension PhotoManager: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let selectedImage = image as? UIImage else { return }
                self.selectedImage = selectedImage
                DispatchQueue.main.async {
                    self.photoDelegate?.pickImage()
                }
            }
        }
    }
}

extension PhotoManager: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("change in manager")
//        let (img, size) = self.getCanAccessImages()
//        self.photoSizes = size
//        self.authorizedPhotos = img
    }
        // getCanAccessImages()
//        self.authorizedPhotos = []
//        guard let details = changeInstance.changeDetails(for: self.fetchResult) else { return }
//        self.update(changes: details.fetchResultAfterChanges)
    
    func requestPHPhotoLibraryAuthorization(completion: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
            switch status {
            case .limited:
                PHPhotoLibrary.shared().register(self)
                completion()
            case .authorized:
                completion()
            default:
                break
            }
        }
    }
}
