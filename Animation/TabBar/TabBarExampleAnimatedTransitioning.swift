import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

class TabBarExampleAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
 
    var isPresenting = false
    
    let fromIndex: Int
    let toIndex: Int
    
    let animMultiplier: Double = 1.0
    
    init(fromIndex: Int, toIndex: Int) {
        self.fromIndex = fromIndex
        self.toIndex = toIndex
        super.init()
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! as UIViewController
        let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as UIViewController
        
        let container = transitionContext.containerView()
        let duration = transitionDuration(transitionContext)
        
        container.addSubview(to.view)
        
        var direction = toIndex > fromIndex ? CGFloat(-1) : CGFloat(1)

        if let toPeople = to as? TabBarPeopleViewController {
            to.view.transform = CGAffineTransformMakeTranslation(0, to.view.bounds.height)
        } else if let fromPeople = from as? TabBarPeopleViewController {
            to.view.alpha = 1.0
            container.addSubview(from.view)
        } else {
            from.view.alpha = 1.0
            to.view.alpha = 0.0
        }
        
        UIView.animateWithDuration(animMultiplier * transitionDuration(transitionContext), delay: animMultiplier * 0.0, options: nil, animations: { () -> Void in
            
            to.view.alpha = 1.0
            to.view.transform = CGAffineTransformIdentity
            
            if let fromPeople = from as? TabBarPeopleViewController {
                fromPeople.view.transform = CGAffineTransformMakeTranslation(0, from.view.bounds.height)
            }
            
        }) { finished in
            
            to.view.transform = CGAffineTransformIdentity
            from.view.transform = CGAffineTransformIdentity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            
        }
    }
    
}
