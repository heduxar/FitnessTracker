//
//  UIView+Ext.swift
//  FitnessTracker
//
//  Created by Юрий Султанов on 27.06.2020.
//  Copyright © 2020 Юрий Султанов. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(color: CGColor = UIColor.black.cgColor,
                   opacity: Float,
                   radius: CGFloat,
                   offset: CGSize = .zero) {
        layer.shadowColor = color
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
    func shake(duration: CFTimeInterval) {
      let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
      translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
      translation.values = [-3, 3, -3, 3, -2, 2, -1, 1, 0]
      
      let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
      rotation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0].map { (degrees: Double) -> Double in
        let radians: Double = (.pi * degrees) / 180.0
        return radians
      }
      
      let shakeGroup: CAAnimationGroup = CAAnimationGroup()
      shakeGroup.animations = [translation, rotation]
      shakeGroup.duration = duration
      self.layer.add(shakeGroup, forKey: "shakeIt")
    }
    
    func show() {
        UIView.animate(withDuration: 0.3) {
            self.isHidden = false
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.isHidden = true
        }
    }
}
