import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    The following class presents the search & search results example. On display
    in this file are the following animations, which happen in sequence:

    1. Navigation bar compresses/expands when keyboard appears/hides
    2. Indeterminate loader while performing the search
    3. Search results animate in from center

    Note that this class does not perform any kind of asynchronous operation to
    get search results. There is a hard-coded delay to display a loader, and
    then a static search result is displayed.
*/

class SearchExampleViewController: ExampleNobelViewController, UITextFieldDelegate {

    // MARK: - Outlets
    
    // MARK: UI Elements
    @IBOutlet weak var searchFieldBackground: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchIcon: UIButton!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var itemsView: UIScrollView!
    @IBOutlet weak var loader: UIImageView!
    @IBOutlet weak var searchTitleLabel: UILabel!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    
    // MARK: Constraints
    @IBOutlet weak var searchFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var searchIconTop: NSLayoutConstraint!
    @IBOutlet weak var searchTitleBottom: NSLayoutConstraint!
    @IBOutlet weak var resultsViewLeft: NSLayoutConstraint!
    @IBOutlet weak var resultsViewRight: NSLayoutConstraint!
    @IBOutlet weak var tableViewLeft: NSLayoutConstraint!
    @IBOutlet weak var tableViewRight: NSLayoutConstraint!
    
    // MARK: - Constants, Properties
    
    let animMultiplier: CGFloat = 2.0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchFieldBackground.backgroundColor = UIColor(white: 0.957, alpha: 1)
        
        tableView.hidden = true
        resultsView.hidden = true
        xButton.hidden = true
        
        self.prepareLoader()
        self.searchField.addTarget(self, action: "textChanged", forControlEvents: .EditingChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchField.resignFirstResponder()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func prepareLoader() -> Void {
        loader.animationImages = [UIImage]()
        
        // grabs the animation frames from the bundle
        for var index = 100; index < 147; index++ {
            var frameName = String(format: "Loader_00%03d", index)
            loader.animationImages?.append(UIImage(named:frameName)!)
        }
        
        loader.animationDuration = 1.5
        loader.stopAnimating()
        loader.hidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func xPressed(sender: AnyObject) {
        self.searchField.text = ""
        self.xButton.hidden = true
        textFieldDidBeginEditing(searchField)
    }
    
    // MARK: - Flow
    
    /**
     * Starts the animation after the enter/submit button has been pressed
     */
    func search(text: String) {
        showResults(text)
    }
    
    /**
     * Gesture recognizer which will hide the keyboard when the user clicks
     * outside of the search textfield.
     */
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        expandHeader()
        hideResults()
    }
    
    /**
     * Performs all of the animations necessary to display the search results
     * 
     * :param: results The string to display as the search result
     */
    func showResults(results: String) {
        resultsLabel.text = results
        disciplineLabel.text = ""
        resultsView.hidden = false
        
        // 1. set animation to initial state
        self.resultsViewLeft.constant = 0
        self.resultsViewRight.constant = 0
        
        resultsView.alpha = 0
        resultsView.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1.0)
        
        loader.alpha = 0
        loader.startAnimating()
        loader.hidden = false
        
        // 2. show indeterminate loader
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.loader.alpha = 1
        }, completion: nil)
        
        // 3. hide loader
        let animationDuration = NSTimeInterval(animMultiplier) * 0.15
        let options = UIViewAnimationOptions.CurveEaseInOut
        UIView.animateWithDuration(animationDuration, delay: 1.5,
            options: options, animations: {
            self.loader.alpha = 0
        }, completion: { finished in
                
            // 4a. cleanup loader
            self.loader.stopAnimating()
            self.loader.hidden = true
            
            // 4b. zoom in the results view
            ViewAnimator.animateView(self.resultsView,
                withDuration: 0.25,
                andEasingFunction: LayoutConstraintEasing.EaseInOutMTF,
                toTransform: CATransform3DIdentity)
            
            // 4c. fade in the results view
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.resultsView.alpha = 1
                self.resultsView.transform = CGAffineTransformIdentity
            }, completion: nil)
        })
        
        expandHeader()
    }
    
    /**
     * Hides the results and displays the initial set of data
     */
    func hideResults() -> Void {
        let animationDuration: Double = Double(animMultiplier * 0.3)
        let animationDelay: NSTimeInterval = 0

        UIView.animateWithDuration(animationDuration, delay: animationDelay,
            options: nil, animations: { () -> Void in
            self.itemsView.alpha = 1.0
            self.tableView.alpha = 1.0
        }, completion: nil)
    }
    
    func collapseHeader() -> Void {
        self.resultsView.alpha = 0
        
        let constraintsToAnimate: [NSLayoutConstraint] = [
            searchIconTop, searchFieldHeight, searchTitleBottom
        ]
        let toValues: [CGFloat] = [30, 40, 0]
        let animationDuration: NSTimeInterval = Double(animMultiplier * 0.2)
        
        LayoutConstraintAnimator(constraints: constraintsToAnimate, delay: 0,
            duration: animationDuration, toConstants: toValues,
            easing: LayoutConstraintEasing.EaseInOut, completion: nil)
        
        UIView.animateWithDuration(Double(animMultiplier) * 0.2, animations: { () -> Void in
            self.searchTitleLabel.transform = CGAffineTransformMakeScale(0.75, 0.75)
        })
        
        UIView.animateWithDuration(Double(animMultiplier) * 0.3, animations: { () -> Void in
            self.tableView.alpha = 0.2
            self.itemsView.alpha = 0.2
        })
    }
    
    func expandHeader() -> Void {
        let constraintsToAnimate: [NSLayoutConstraint] = [
            searchIconTop, searchFieldHeight, searchTitleBottom
        ]
        let toValues: [CGFloat] = [70, 80, 18]
        let animationDuration: Double = Double(animMultiplier * 0.3)
        let animationDelay: NSTimeInterval = 0
        
        LayoutConstraintAnimator(constraints: constraintsToAnimate,
            delay: 0, duration: animationDuration, toConstants: toValues,
            easing: LayoutConstraintEasing.EaseInOut, completion: nil)
        
        UIView.animateWithDuration(Double(self.animMultiplier) * 0.3, animations: { () -> Void in
            self.searchTitleLabel.transform = CGAffineTransformIdentity
        })
        
        xButton.hidden = true
        
        let delay = Double(animMultiplier) * 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
            self.searchField.resignFirstResponder()
        })
    }
    
    // MARK: - Appearance
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    // MARK: - Text Field
    
    func textChanged() -> Void {
        self.xButton.hidden = count(self.searchField.text) == 0
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.collapseHeader()
        
        self.xButton.hidden = count(textField.text) == 0
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if count(textField.text) < 2 {
            return false
        }
        
        search(textField.text)
        
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
}
