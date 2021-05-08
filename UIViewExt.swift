//
//  UIViewExt.swift
//  Created by LYNX ART on 08/05/2021.
//

import UIKit

extension UIView {
/**
     Call this to animate the selected UIView with a shake animation, usually on UITextField when there is a validation error
     
     Inspired by rakeshbs answer -
     https://stackoverflow.com/questions/27987048/shake-animation-for-uitextfield-uiview-in-swift/38790163

     * EXAMPLE:
       
         On a UITextField:
         ````
         txtPassword.shakeAnimation()
         ````
     - Author:
         Omar Al Qasmi
     - Version:
         1.0
*/
    func shakeAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 6, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 6, y: self.center.y))

        self.layer.add(animation, forKey: "position")
    }
}

