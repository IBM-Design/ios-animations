import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    The following class presents the modal example. It shows a grid view of
    buttons that, when clicked, will present a modal popup over the main view.

    On display in this file are the following animations, which happen
    in sequence:

    1. The modal slides up from the bottom of the screen with custom easing
    2. The indeterminate loader appears while the content loads
    3. The content fades in and zooms in from the center of the screen
*/

class ModalViewController: UIViewController, UITableViewDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var buttonImageView: UIImageView!
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var modalBackgroundTop: NSLayoutConstraint!
    @IBOutlet weak var modalHeadHeight: NSLayoutConstraint!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var modalHead: UIView!
    @IBOutlet weak var loaderBG: UIView!
    @IBOutlet weak var loader: UIImageView!
    @IBOutlet weak var pdfView: UIWebView!
    
    // MARK: - Constants, Properties
    
    var modalPressed: ((index: Int) -> Void)?
    
    let animationMultiplier : CGFloat = 1
    let maxModalHeadHeight: CGFloat = 80
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalHeadHeight.constant = modalHead.bounds.size.height
        modalBackgroundTop.constant = UIScreen.mainScreen().bounds.size.height - 50
        
        self.pdfView.alpha = 0
        
        loader.animationImages = [UIImage]()
        
        for var index = 100; index < 147; index++ {
            var frameName = String(format: "Loader_00%03d", index)
            loader.animationImages?.append(UIImage(named:frameName)!)
        }
        
        pdfView.scrollView.delegate = self
        
        loader.animationDuration = 1.5
        loader.startAnimating()
    }
    
    // MARK: - Scroll View
    
    // header shrinks and its elements resize based on scroll position
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // update views based on scroll offset
        
        let scrollOffset = scrollView.contentOffset.y
        let maxScrollOffset: CGFloat = 40
        
        // scalePerfect :       1 when modalHead at full size (at top of scroll), 0 when hodalHead is at it's smallest
        // labelEndPercent :    percentage of height of label at it's smallest
        let scalePercent = (self.modalHead.bounds.height - 40) / maxModalHeadHeight * 2
        let labelEndPercent = (self.modalHead.bounds.height / maxModalHeadHeight) + (0.15 * (1 - scalePercent))
        
        self.view.layoutIfNeeded()
        
        if (scrollOffset < 0) {
            // at top
            // set to max position
            self.menuLabel.transform = CGAffineTransformIdentity
            self.buttonImageView.alpha = 1
            self.closeButton.enabled = true
            
            UIView.animateWithDuration(0.1, animations: {
                self.modalHeadHeight.constant = 80
                self.view.layoutIfNeeded()
            })
        } else {
            // between max and min scale
            // proportionally adjust the header and it's children
            if scrollOffset < maxScrollOffset {
                self.buttonImageView.alpha = scalePercent
                self.closeButton.enabled = true
                self.menuLabel.transform = CGAffineTransformMakeScale(labelEndPercent, labelEndPercent)
                self.buttonImageView.transform = CGAffineTransformMakeScale(labelEndPercent, labelEndPercent)
                
                UIView.animateWithDuration(0.1, animations: {
                    self.modalHeadHeight.constant = (80 - scrollOffset)
                    self.view.layoutIfNeeded()
                })
            } else {
                // scrolled beyond minimun
                // set to min position
                self.buttonImageView.alpha = 0
                self.closeButton.enabled = false
                self.menuLabel.transform = CGAffineTransformMakeScale((self.modalHead.bounds.height / maxModalHeadHeight) + 0.15, (self.modalHead.bounds.height / maxModalHeadHeight) + 0.2)
                
                UIView.animateWithDuration(0.1, animations: {
                    self.modalHeadHeight.constant = 40
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    // MARK: - Transition Animations
    
    func show(completion: () -> Void ) {
    
        var animationDuration = Double(self.animationMultiplier) * 1 / 3.0;
        
        backgroundView.alpha = 0
        loaderBG.alpha = 1
        loader.alpha = 1
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            
            self.backgroundView.alpha = 1
        }, completion: { finished in
            // display PDF
            // first string value is pdf file name
            var pdfLoc = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Bee", ofType:"pdf")!)
            var request = NSURLRequest(URL: pdfLoc!);
            self.pdfView.loadRequest(request);
            self.pdfView.alpha = 0
            self.pdfView.transform = CGAffineTransformMakeScale(0.75, 0.75)
            
            // show PDF
            UIView.animateWithDuration(animationDuration, delay: 1.5, options: nil, animations: { () -> Void in
                    self.loader.alpha = 0 // fade out loader
                }, completion: { finished in
                    UIView.animateWithDuration(0.25, delay: 0, options: nil, animations: { () -> Void in
                            // fade in PDF
                            self.loaderBG.alpha = 0
                            self.pdfView.alpha = 1
                            self.pdfView.transform = CGAffineTransformIdentity
                        }, completion: { finished in
                            
                    })
            })
            
        })
        
        var timer = LayoutConstraintAnimator(constraint: self.modalBackgroundTop, delay: 0, duration: animationDuration, toConstant: CGFloat(0), easing: LayoutConstraintEasing.Bezier(x1: 0.5, y1: 0.08, x2: 0.0, y2: 1.0), completion: completion)
    }
    
    func hide(completion: () -> Void ) {
        
        var animationDuration = Double(self.animationMultiplier) * 1 / 4.0;
        
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.backgroundView.alpha = 0
        })
        
        var timer = LayoutConstraintAnimator(constraint: self.modalBackgroundTop, delay: 0, duration: animationDuration, toConstant: (UIScreen.mainScreen().bounds.size.height + 10), easing: LayoutConstraintEasing.Bezier(x1: 0.5, y1: 0.08, x2: 0.0, y2: 1.0)) { finished in
            
            self.modalPressed?(index:0)
            completion()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func hideAction(sender: AnyObject) {
        closeButton.hidden = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Appearance
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
