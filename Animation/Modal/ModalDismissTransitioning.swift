import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

class ModalDismissTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.8
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        let to = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let from = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ModalViewController

        let container = transitionContext.containerView()
        let duration = transitionDuration(transitionContext)
        
        container.insertSubview(to.view, atIndex: 0)

        from.hide() {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            
            // Because the From View Controller disappears using UIViewControllerContextTransitioning,
            // re-add the toViewController's view as a subview of the key window's.
            // This is a solution for an iOS 8 bug. For details, see:
            // http://stackoverflow.com/questions/24338700/from-view-controller-disappears-using-uiviewcontrollercontexttransitioning
            UIApplication.sharedApplication().keyWindow!.addSubview(to.view)
        }
     
    }
    
}
