//
//  PhotoManager.swift
//  Winey
//
//  Created by 김응관 on 2023/08/31.
//

import UIKit
import Photos
import PhotosUI

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
    
    var thumbnailSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: UIScreen.main.bounds.width)
    }
    
    lazy var photoPicker: PHPickerViewController = {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        config.preselectedAssetIdentifiers = []
        let imgPicker = PHPickerViewController(configuration: config)
        imgPicker.delegate = self
        return imgPicker
    }()
    
    let alertController: UIAlertController = {
        let alert = UIAlertController(title: "권한 거부됨",
                                      message: "갤러리 접근이 거부 되었습니다.\n피드 작성이 불가합니다",
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
        
        alert.addAction(allowAction)
        alert.addAction(cancelAction)
        
        return alert
    }()
    
    func clearPreselectedAssets() {
        // 이미지 선택 초기화
        selectedImage = nil
        photoPicker = {
            var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 1
            config.preselectedAssetIdentifiers = []
            
            let imgPicker = PHPickerViewController(configuration: config)
            imgPicker.delegate = self
            return imgPicker
        }()
        
        present(photoPicker, animated: true, completion: nil)
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
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                guard let selectedImage = image as? UIImage else { return }
                DispatchQueue.main.async {
                    picker.dismiss(animated: true) {
                        self.selectedImage = selectedImage
                        self.photoDelegate?.pickImage()
                    }
                }
                self.selectedImage = nil
            }
        }
    }
}

