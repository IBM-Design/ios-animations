import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    This view controller exists to provide a means of returning to the main menu
    from any of the sample scenarios.
*/

class MainNavigationViewController: UINavigationController {

    // MARK: - Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a long press recognizer that requires two fingers and reverts the navigation back to the
        // main menu.
        var longPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("longPress:"))
        longPressRecognizer.numberOfTouchesRequired = 2
        view.addGestureRecognizer(longPressRecognizer)
    }
    
    // MARK: - Flow
    
    func longPress(longPress: UILongPressGestureRecognizer) {
        popToRootViewControllerAnimated(true)
    }
    
}
