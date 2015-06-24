import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/** 
    This class takes care of animating NSLayoutConstraints with custom easing
    curves. It runs a display link that calculates the appropriate constant
    value for an array of layout constraints. This is currently the best way of
    achieving this.
*/

class LayoutConstraintAnimator: NSObject {
    
    internal lazy var link: CADisplayLink = CADisplayLink(target: self, selector: Selector("timer"))
    internal var startTime: Double
    internal var fromConstants: [CGFloat]
    internal var delaying: Bool
    
    let constraints: [NSLayoutConstraint]
    let delay: Double
    let duration: Double
    let toConstants: [CGFloat]
    let easing: LayoutConstraintEasing
    let completion : (() -> Void)?

    /**
    Convenience constructor for the animation. Simply wraps the constraint and
    toConstant in an array for the main constructor.
    */
    convenience init(constraint: NSLayoutConstraint, delay:NSTimeInterval,
        duration:NSTimeInterval, toConstant:CGFloat, easing: LayoutConstraintEasing,
        completion: (() -> Void)?) {
    
        self.init(
            constraints:[constraint], delay:delay, duration:duration,
            toConstants:[toConstant], easing:easing, completion:completion
        )
    }
    
    /**
    The constructor for the animation. Once the animation is created, it is not
    able to be modified or stopped.
    
    :param: constraints The set of constraints to be animated
    :param: delay The delay, in seconds, before beginning the animation
    :param: duration The duration, in seconds, of the animation to be performed
    :param: toConstants The values of the constants to be set on each of the constraints
    :param: easing The easing algorithm to be used when calculating the target's values
    :param: completion The block to be performed on completion of the animation
    */
    required init(constraints: [NSLayoutConstraint], delay:NSTimeInterval,
        duration:NSTimeInterval, toConstants:[CGFloat], easing: LayoutConstraintEasing,
        completion: (() -> Void)?) {
        
        self.constraints = constraints
        self.delay = Double(delay)
        self.duration = Double(duration)
        self.toConstants = toConstants
        self.easing = easing
        self.completion = completion
        
        self.fromConstants = [CGFloat]()
        for constraint in constraints {
            self.fromConstants.append(constraint.constant)
        }
        
        self.startTime = CACurrentMediaTime()
        self.delaying = delay != 0
        
        super.init()
        
        self.link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    internal func timer() {
        // checks to see if we should continue delaying or process the animation
        if delaying {
            if (CACurrentMediaTime() - startTime) >= delay {
                delaying = false
                startTime = CACurrentMediaTime()
            } else {
                return
            }
        }
        
        var time = CGFloat((CACurrentMediaTime() - startTime) / duration)
        
        // check to see if the animation has completed
        if time >= 1 {
            for (index, constraint) in enumerate(constraints) {
                constraint.constant = toConstants[index]
            }
            
            link.invalidate()
            link.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
            
            if let completion = completion {
                completion()
            }

            return
        }
        
        // process the animation
        var t = easing.valueFor(CGFloat(time))
        
        for (index, constraint) in enumerate(constraints) {
            constraint.constant = (1 - t) * fromConstants[index] + t * toConstants[index]
        }
    }
}