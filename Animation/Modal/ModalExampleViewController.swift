import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    The following class presents the modal example. Most of the work is actually
    done in the ModalViewController class, so check that out for all of the
    animation implementation.

    This class just hands off some dependencies to the ModalViewController once
    the button is clicked. See the prepareForSegue:sender: method to see what
    is being handed off.

    This class subclasses ExampleNobelViewController in order to get a dummy
    set of data to display in a UITableView. It is not necessary to understand
    how that class functions in order to follow the animation example code.
*/

class ModalExampleViewController: ExampleNobelViewController {

    // MARK: - Constants, Properties
    
    var hiddenStatusBar:Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    let modalTransitioningDelegate = ModalTransitioningDelegate()
    
    // MARK: - Lifecycle
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var modalVC = segue.destinationViewController as! ModalViewController
        modalVC.modalPresentationStyle = .Custom
        modalVC.transitioningDelegate = modalTransitioningDelegate
        
        hiddenStatusBar = false
    }
    
    // MARK: - Appearance
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return hiddenStatusBar
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
