//
//  LimitedPickerViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/08/31.
//

import Combine
import UIKit

import DesignSystem
import SnapKit
import PhotosUI

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

class LimitedPickerViewController: UIViewController {
    
    let imageSpace: CGFloat = 2.0
    let imageManager = PHCachingImageManager()
    let scale = UIScreen.main.scale
    
    var fetchResult = PHFetchResult<PHAsset>()
    var authorizeImages = [UIImage]()
    
    var thumbnailSize = CGSize()
    var selectedImageSize = CGSize()
    
    var previousPreheatRect = CGRect.zero
    var availableWidth: CGFloat = 0
    
    private var bag = Set<AnyCancellable>()

    // MARK: - UI Components
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: (((UIScreen.main.bounds.width) - (self.imageSpace * 3)) / 4),
                                 height: (((UIScreen.main.bounds.width) - (self.imageSpace * 3)) / 4))
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.register(LimitedPickerCollectionViewCell.self, forCellWithReuseIdentifier: LimitedPickerCollectionViewCell.className)
        view.showsVerticalScrollIndicator = true
        return view
    }()
    
    private let navigationBar = WINavigationBar(leftBarItem: .back, title: "Photos")
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cellSize = flowLayout.itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCachedAssets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAddTarget()
        setLayout()
        setCollectionView()
        setUI()
        bind()
        PHPhotoLibrary.shared().register(self)
        imageManager.allowsCachingHighQualityImages = true
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func setUI() {
        view.backgroundColor = .winey_gray0
    }
    
    func bind() {
        NotificationCenter.default.publisher(for: .whenEnterForeground)
            .sink(receiveValue: { [weak self] _ in
                self?.updateCachedAssets()
                self?.collectionView.reloadData()
            })
            .store(in: &bag)
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    private func setAddTarget() {
        navigationBar.leftButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func cancelButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setLayout() {
        view.addSubviews(navigationBar, collectionView)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(4)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func updateCachedAssets() {
        guard isViewLoaded && view.window != nil else { return }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 4 else { return }
        
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        
        if fetchResult != PHFetchResult<PHAsset>() {
            let addedAssets = addedRects
                .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
                .map { indexPath in fetchResult.object(at: indexPath.item) }
            let removedAssets = removedRects
                .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
                .map { indexPath in fetchResult.object(at: indexPath.item) }
            
            imageManager.startCachingImages(for: addedAssets,
                                            targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
            imageManager.stopCachingImages(for: removedAssets,
                                           targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
            
            previousPreheatRect = preheatRect
        } else { return }
    }
    
    private func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
    
    private func setHeight(_ width: CGFloat, _ height: CGFloat) -> CGFloat {
        let ratio = width / UIScreen.main.bounds.width
        let scaledHeight = height * ratio
        
        return scaledHeight
    }
}

extension LimitedPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LimitedPickerCollectionViewCell.className, for: indexPath) as? LimitedPickerCollectionViewCell else { return LimitedPickerCollectionViewCell() }
        
        // if let fetchResult = fetchResult {
            let asset = fetchResult.object(at: indexPath.item)
            
            cell.representedAssetIdentifier = asset.localIdentifier
            imageManager.requestImage(for: asset,
                                      targetSize: thumbnailSize,
                                      contentMode: .aspectFill,
                                      options: nil, resultHandler: { image, _ in
                guard let image = image else { return }
                if cell.representedAssetIdentifier == asset.localIdentifier {
                    cell.thumbnailImage = image
                    cell.originalSize = image.size
                }
            })
        // }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? LimitedPickerCollectionViewCell else { return }
        
        let ratio = cell.originalSize.height / cell.originalSize.width
        let width = (UIScreen.main.bounds.width)
        let height = ratio * width
        
        // if let fetchResult = fetchResult {
            let asset = fetchResult.object(at: indexPath.item)
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.isNetworkAccessAllowed = true
            requestOptions.isSynchronous = true
            requestOptions.resizeMode = .exact
            
            imageManager.requestImage(for: asset,
                                      targetSize: CGSize(width: width * scale, height: height * scale * ratio),
                                      contentMode: .aspectFill,
                                      options: requestOptions) { image, _ in
                guard let image = image else { return }
                
                NotificationCenter.default.post(name: .whenImgSelected, object: nil, userInfo: ["img": image])
                
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        // }
    }
}

extension LimitedPickerViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: fetchResult)
        else { return }
        
        DispatchQueue.main.sync {
            _ = changes.fetchResultAfterChanges
            if changes.hasIncrementalChanges {
                collectionView.performBatchUpdates({
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        self.collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                     to: IndexPath(item: toIndex, section: 0))
                    }
                })
                
                if let changed = changes.changedIndexes, !changed.isEmpty {
                    collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                }
            } else {
                collectionView.reloadData()
            }
            resetCachedAssets()
        }
    }
}
