import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

class ViewAnimator: NSObject {
   
    static func animateView(view: UIView, withDuration duration: CFTimeInterval,
        andEasingFunction easingFunction:CAMediaTimingFunction,
        toTransform transform: CATransform3D) {
        
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(easingFunction)
    
        let anim: CABasicAnimation = CABasicAnimation(keyPath: "transform")
        anim.fromValue = NSValue(CATransform3D: view.layer.transform)
        anim.toValue   = NSValue(CATransform3D: transform)
        view.layer.addAnimation(anim, forKey: "animateTransform")
    
        CATransaction.setCompletionBlock {
            view.layer.transform = transform
        }
        
        CATransaction.commit()
    }
}
