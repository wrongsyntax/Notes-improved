//
//  UIView.swift
//  Notes-improved
//
//  Created by Uzair Tariq on 2022-11-16.
//  Copyright © 2022 Uzair Tariq. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeInAnimation(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }

    func fadeOutAnimation(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
    
    func addDashedBorder() {
        let color = UIColor.label.resolvedColor(with: self.traitCollection).withAlphaComponent(0.5).cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6, 5]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 20).cgPath

        self.layer.addSublayer(shapeLayer)
    }    
}
