//
//  GalleryViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/08/31.
//

import Combine
import UIKit
import Photos

import DesignSystem
import SnapKit

class GalleryViewController: UIViewController {
    
    var allPhotos: PHFetchResult<PHAsset>?
    let imageSpace: CGFloat = 2
    var thumbnailSize: CGSize {
        return CGSize(width: (((UIScreen.main.bounds.width) - (imageSpace * 3)) / 4),
                      height: (((UIScreen.main.bounds.width) - (imageSpace * 3)) / 4))
    }
    
    let vc = LimitedPickerViewController()
    
    private var tumbnailImg: UIImage?
    private var imgCount: Int = 0
    
    private let navigationBar = WINavigationBar(leftBarItem: .back, title: "Photos")
    private var bag = Set<AnyCancellable>()
    
    private let flowLayout: UICollectionViewLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.className)
        view.showsVerticalScrollIndicator = true
        view.backgroundColor = .winey_gray0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setUI()
        setAddTarget()
        setLayout()
        bind()
        setPhotoFetch()
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func bind() {
        NotificationCenter.default.publisher(for: .whenEnterForeground)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }

                self.setPhotoFetch()
                self.collectionView.reloadData()
                self.vc.fetchResult = self.allPhotos ?? PHFetchResult<PHAsset>()
            })
            .store(in: &bag)
    }
    
    func setUI() {
        view.backgroundColor = .winey_gray0
    }
    
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setAddTarget() {
        navigationBar.leftButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
    func setLayout() {
        view.addSubviews(navigationBar, collectionView)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func setPhotoFetch() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        
        if let albums = allPhotos {
            sendTunmbnail(albums.firstObject)
            setImageCount(albums.count)
        } else {
            sendTunmbnail(nil)
            setImageCount(0)
        }
        
        PHPhotoLibrary.shared().register(self)
    }
    
    private func sendTunmbnail(_ target: PHAsset?) {
        
        if let target = target {
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.isNetworkAccessAllowed = true
            requestOptions.isSynchronous = true
            requestOptions.resizeMode = .exact
            
            PHCachingImageManager().startCachingImages(for: [target],
                                                       targetSize: CGSize(width: 80, height: 80),
                                                       contentMode: .aspectFill,
                                                       options: requestOptions)
            
            PHImageManager().requestImage(for: target,
                                          targetSize: CGSize(width: 80, height: 80),
                                          contentMode: .aspectFill,
                                          options: requestOptions, resultHandler: { [weak self] image, _ in
                guard let image = image else { return }
                guard let self = self else { return }
                self.tumbnailImg = image
            })
        } else { tumbnailImg = nil }
    }
    
    private func setImageCount(_ count: Int) {
        imgCount = count
    }
    
    @objc
    private func cancelButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.className, for: indexPath) as? GalleryCell else { return GalleryCell() }
        cell.configure(tumbnailImg, imgCount)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vc.fetchResult = allPhotos ?? PHFetchResult<PHAsset>()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GalleryViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            guard let album = allPhotos else { return }
            if let changeDetails = changeInstance.changeDetails(for: album) {
                let changedAlbum = changeDetails.fetchResultAfterChanges
                sendTunmbnail(changedAlbum.firstObject)
                setImageCount(changedAlbum.count)
            }
        }
    }
}
