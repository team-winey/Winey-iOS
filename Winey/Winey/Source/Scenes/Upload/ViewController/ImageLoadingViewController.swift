//
//  ImageLoadingViewController.swift
//  Winey
//
//  Created by 김응관 on 2023/08/29.
//

import Combine
import UIKit
import Photos

import DesignSystem

class ImageLoadingViewController: UIViewController {
    
    private var bag = Set<AnyCancellable>()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = self.view.center
        activityIndicator.color = .winey_gray600
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "추가된 사진이 많으면 시간이 오래걸릴수도 있습니다"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalTo(activityIndicator.snp.bottom).offset(30)
            $0.centerY.equalToSuperview()
        }
    }

    func setUI() {
        view.backgroundColor = .winey_gray0
        view.alpha = 0.6
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func bind() {
        NotificationCenter.default.publisher(for: .imgLoadingEnd)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: false)
                }
            }
            .store(in: &bag)
    }
}
