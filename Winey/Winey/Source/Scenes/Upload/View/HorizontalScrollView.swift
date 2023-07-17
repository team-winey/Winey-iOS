//
//  HorizontalScrollView.swift
//  Winey
//
//  Created by 김응관 on 2023/07/12.
//

import UIKit

class HorizontalScrollView: UIScrollView {
    
    // MARK: - Properties
    
    private let spacing: CGFloat = 17
    var viewWidth: CGFloat = UIScreen.bounds.size.width - (2*spacing)

    // MARK: - UI Components
    
//    private lazy var scrollView: UIScrollView = {
//        let view = UIScrollView()
//        view.isScrollEnabled = false
//        view.isPagingEnabled = true
//        view.showsHorizontalScrollIndicator = false
//        view.showsVerticalScrollIndicator = false
//        view.backgroundColor = .white
//        return view
//    }()
    
    // MARK: - Methods
    
    func setUI() {
        var x: CGFloat = 0
        
        for _ in 0..<3 {
            let component: PhotoUploadView = PhotoUploadView(frame: CGRect(x: x+spacing, y: 0, width: viewWidth, height: 182))
            
            component.backgroundColor = .white
            self.addSubview(component)
            
            x = frame.origin.x + viewWidth + spacing
        }
        
        self.contentSize = CGSize(width: x + spacing, height: self.frame.size.height)
    }
    
    // MARK: - Init Methods
    
    
    
}
