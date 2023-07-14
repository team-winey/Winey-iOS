//
//  MIButton.swift
//  
//
//  Created by Woody Lee on 2023/07/14.
//

import UIKit

public final class MIButton: UIButton {
    private let type: MIButtonType
    
    public override var isHighlighted: Bool {
        didSet {
            var transform = CGAffineTransform.identity
            if self.isHighlighted { transform = transform.scaledBy(x: 0.9, y: 0.9) }
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0,
                options: [],
                animations: { self.transform = transform }
            )
        }
    }
    
    public init(type: MIButtonType) {
        self.type = type
        super.init(frame: .zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    private func setUI() {
        setTitleColor(self.type.titleColor, for: .normal)
        setTitleColor(self.type.titleColor, for: .highlighted)
        setBackgroundColor(self.type.backgroundColor, for: .normal)
        setBackgroundColor(self.type.backgroundColor, for: .highlighted)
    }
}

private extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
