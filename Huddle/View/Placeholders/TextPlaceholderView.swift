//
//  TextPlaceholderView.swift
//  Huddle
//
//  Created by Dan Mitu on 1/18/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class TextPlaceholderView: UIView {
    
    var color = UIColor(red: 0.929, green: 0.941, blue: 0.945, alpha: 1.000) { didSet { setNeedsDisplay() } }
    
    /// The distance from the top, left, and right edges
    var edgeInset: CGFloat = 4 { didSet { setNeedsDisplay() } }
    
    /// The height of the lines (think font sizes).
    var pointSize: CGFloat = 12 { didSet { setNeedsDisplay() } }
    
    var distanceBetweenLines: CGFloat = 4 { didSet { setNeedsDisplay() } }
    
    var cornerRadius: CGFloat = 50 { didSet { setNeedsDisplay() } }
    
    var lastLineScale: CGFloat = 0.85 {
        didSet {
            guard lastLineScale >= 0 else {
                lastLineScale = 0
                return
            }
            guard lastLineScale <= 1 else {
                lastLineScale = 1
                return
            }
            setNeedsDisplay()
        }
    }
    
    /// - fill: Draw as many complete lines as possible
    /// - lines: Draw an exact number of lines
    enum TextPlaceholderMode {
        case fill
        case lines(count: Int)
    }
    
    var mode: TextPlaceholderMode = .fill { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let lineSize = CGSize(width: rect.width - (2 * edgeInset), height: pointSize)
        let linePath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: edgeInset, y: edgeInset), size: lineSize), cornerRadius: cornerRadius)
        
        self.color.setFill()
        
        switch mode {
        case .fill:
            var haveEnoughRoomForAnotherLine: Bool = rect.height >= (lineSize.height + (2 * edgeInset))
            while haveEnoughRoomForAnotherLine {
                let isLastLine = rect.height < (linePath.currentPoint.y + lineSize.height + max(edgeInset, distanceBetweenLines) + distanceBetweenLines + lineSize.height)
                if isLastLine {
                    linePath.apply(CGAffineTransform(scaleX: lastLineScale, y: 1))
                }
                linePath.fill()
                linePath.apply(CGAffineTransform(translationX: 0, y: distanceBetweenLines + lineSize.height))
                haveEnoughRoomForAnotherLine = rect.height >= (linePath.currentPoint.y + lineSize.height + max(edgeInset, distanceBetweenLines))
            }
        case .lines(count: let n):
            for i in 0..<n {
                if i == (n - 1) {
                    linePath.apply(CGAffineTransform(scaleX: lastLineScale, y: 1))
                }
                linePath.fill()
                linePath.apply(CGAffineTransform(translationX: 0, y: distanceBetweenLines + lineSize.height))
                
            }
        }
    }
    
}
