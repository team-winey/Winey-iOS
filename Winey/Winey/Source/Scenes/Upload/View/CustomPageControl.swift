////
////  CustomPageControl.swift
////  Winey
////
////  Created by 김응관 on 2023/07/11.
////
//
//import UIKit
//
//
//open class CHIPageControlAji: CHIBasePageControl {
//    
//    fileprivate var diameter: CGFloat {
//        return radius * 2
//    }
//
//    fileprivate var inactive = [CHILayer]()
//    fileprivate var active = CHILayer()
//
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    override func updateNumberOfPages(_ count: Int) {
//        inactive.forEach { $0.removeFromSuperlayer() }
//        inactive = [CHILayer]()
//        inactive = (0..<count).map {_ in
//            let layer = CHILayer()
//            self.layer.addSublayer(layer)
//            return layer
//        }
//
//        self.layer.addSublayer(active)
//        setNeedsLayout()
//        self.invalidateIntrinsicContentSize()
//    }
//
//    override open func layoutSubviews() {
//        super.layoutSubviews()
//        
//        let floatCount = CGFloat(inactive.count)
//        let x = ceil((self.bounds.size.width - self.diameter*floatCount - self.padding*(floatCount-1))*0.5)
//        let y = ceil((self.bounds.size.height - self.diameter)*0.5)
//        var frame = CGRect(x: x, y: y, width: self.diameter, height: self.diameter)
//
//        active.cornerRadius = self.radius
//        active.backgroundColor = (self.currentPageTintColor ?? self.tintColor)?.cgColor
//        active.frame = frame
//
//        inactive.enumerated().forEach() { index, layer in
//            layer.backgroundColor = self.tintColor(position: index).withAlphaComponent(self.inactiveTransparency).cgColor
//            if self.borderWidth > 0 {
//                layer.borderWidth = self.borderWidth
//                layer.borderColor = self.tintColor(position: index).cgColor
//            }
//            layer.cornerRadius = self.radius
//            layer.frame = frame
//            frame.origin.x += self.diameter + self.padding
//        }
//        update(for: progress)
//    }
//
//    override func update(for progress: Double) {
//        guard let min = inactive.first?.frame,
//              let max = inactive.last?.frame,
//              numberOfPages > 1,
//              progress >= 0 && progress <= Double(numberOfPages - 1) else {
//                return
//        }
//
//        let total = Double(numberOfPages - 1)
//        let dist = max.origin.x - min.origin.x
//        let percent = CGFloat(progress / total)
//
//        let offset = dist * percent
//        active.frame.origin.x = min.origin.x + offset
//    }
//
//    override open var intrinsicContentSize: CGSize {
//        return sizeThatFits(CGSize.zero)
//    }
//
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize(width: CGFloat(inactive.count) * self.diameter + CGFloat(inactive.count - 1) * self.padding,
//                      height: self.diameter)
//    }
//    
//    override open func didTouch(gesture: UITapGestureRecognizer) {
//        let point = gesture.location(ofTouch: 0, in: self)
//        if let touchIndex = inactive.enumerated().first(where: { $0.element.hitTest(point) != nil })?.offset {
//            delegate?.didTouch(pager: self, index: touchIndex)
//        }
//    }
//}
//
////@IBDesignable open class FilledPageControl: UIView {
////
////    // MARK: - PageControl
////
////    @IBInspectable open var pageCount: Int = 0 {
////        didSet {
////            updateNumberOfPages(pageCount)
////        }
////    }
////    @IBInspectable open var progress: CGFloat = 0 {
////        didSet {
////            updateActivePageIndicatorMasks(forProgress: progress)
////        }
////    }
////    open var currentPage: Int {
////        return Int(round(progress))
////    }
////
////    // MARK: - Appearance
////
////    override open var tintColor: UIColor! {
////        didSet {
////            inactiveLayers.forEach() { $0.backgroundColor = tintColor.cgColor }
////        }
////    }
////    @IBInspectable open var inactiveRingWidth: CGFloat = 0 {
////        didSet {
////            updateActivePageIndicatorMasks(forProgress: progress)
////        }
////    }
////    @IBInspectable open var indicatorPadding: CGFloat = 10 {
////        didSet {
////            layoutPageIndicators(inactiveLayers)
////        }
////    }
////    @IBInspectable open var indicatorRadius: CGFloat = 5 {
////        didSet {
////            layoutPageIndicators(inactiveLayers)
////        }
////    }
////
////    fileprivate var indicatorDiameter: CGFloat {
////        return indicatorRadius * 2
////    }
////    fileprivate var inactiveLayers = [CALayer]()
////
////    // MARK: - State Update
////
////    fileprivate func updateNumberOfPages(_ count: Int) {
////        // no need to update
////        guard count != inactiveLayers.count else { return }
////        // reset current layout
////        inactiveLayers.forEach() { $0.removeFromSuperlayer() }
////        inactiveLayers = [CALayer]()
////        // add layers for new page count
////        inactiveLayers = stride(from: 0, to:count, by:1).map() { _ in
////            let layer = CALayer()
////            layer.backgroundColor = self.tintColor.cgColor
////            self.layer.addSublayer(layer)
////            return layer
////        }
////        layoutPageIndicators(inactiveLayers)
////        updateActivePageIndicatorMasks(forProgress: progress)
////        self.invalidateIntrinsicContentSize()
////    }
////
////    // MARK: - Layout
////
////    fileprivate func updateActivePageIndicatorMasks(forProgress progress: CGFloat) {
////        // ignore if progress is outside of page indicators' bounds
////        guard progress >= 0 && progress <= CGFloat(pageCount - 1) else { return }
////
////        // mask rect w/ default stroke width
////        let insetRect = CGRect(x: 0, y: 0, width: indicatorDiameter, height: indicatorDiameter).insetBy(dx: inactiveRingWidth, dy: inactiveRingWidth)
////        let leftPageFloat = trunc(progress)
////        let leftPageInt = Int(progress)
////
////        // inset right moving page indicator
////        let spaceToMove = insetRect.width / 2
////        let percentPastLeftIndicator = progress - leftPageFloat
////        let additionalSpaceToInsetRight = spaceToMove * percentPastLeftIndicator
////        let closestRightInsetRect = insetRect.insetBy(dx: additionalSpaceToInsetRight, dy: additionalSpaceToInsetRight)
////
////        // inset left moving page indicator
////        let additionalSpaceToInsetLeft = (1 - percentPastLeftIndicator) * spaceToMove
////        let closestLeftInsetRect = insetRect.insetBy(dx: additionalSpaceToInsetLeft, dy: additionalSpaceToInsetLeft)
////
////        // adjust masks
////        for (idx, layer) in inactiveLayers.enumerated() {
////            let maskLayer = CAShapeLayer()
////            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
////
////            let boundsPath = UIBezierPath(rect: layer.bounds)
////            let circlePath: UIBezierPath
////            if leftPageInt == idx {
////                circlePath = UIBezierPath(ovalIn: closestLeftInsetRect)
////            } else if leftPageInt + 1 == idx {
////                circlePath = UIBezierPath(ovalIn: closestRightInsetRect)
////            } else {
////                circlePath = UIBezierPath(ovalIn: insetRect)
////            }
////            boundsPath.append(circlePath)
////            maskLayer.path = boundsPath.cgPath
////            layer.mask = maskLayer
////        }
////    }
////
////    fileprivate func layoutPageIndicators(_ layers: [CALayer]) {
////        let layerDiameter = indicatorRadius * 2
////        var layerFrame = CGRect(x: 0, y: 0, width: layerDiameter, height: layerDiameter)
////        layers.forEach() { layer in
////            layer.cornerRadius = self.indicatorRadius
////            layer.frame = layerFrame
////            layerFrame.origin.x += layerDiameter + indicatorPadding
////        }
////    }
////
////    override open var intrinsicContentSize: CGSize {
////        return sizeThatFits(CGSize.zero)
////    }
////
////    override open func sizeThatFits(_ size: CGSize) -> CGSize {
////        let layerDiameter = indicatorRadius * 2
////        return CGSize(width: CGFloat(inactiveLayers.count) * layerDiameter + CGFloat(inactiveLayers.count - 1) * indicatorPadding,
////                      height: layerDiameter)
////    }
////}
