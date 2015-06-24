import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    The following class presents the modal example. Most of the work is actually
    done in the DropdownExampleViewController class, so check that out for all
    of the animation implementation.

    This class just hands off some dependencies to the
    DropdownExampleViewController once the button is clicked. See the
    prepareForSegue:sender: method to see what is being handed off.

    This class subclasses ExampleNobelViewController in order to get a dummy
    set of data to display in a UITableView. It is not necessary to understand
    how that class functions in order to follow the animation example code.
*/

class DropdownExampleViewController: ExampleNobelViewController, DropDownViewControllerDelegate {

    // MARK: - Outlets

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dropdownButtonImage: UIImageView!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var dropdownView: UIView!
    
    // MARK: - Constants, Properties

    var isOpen = false
    var dropdownVC: DropdownViewController!
    let animationMultiplier : CGFloat = 1;
    let animationImages: [UIImage] = [
        UIImage(named: "circle_x_00")!,
        UIImage(named: "circle_x_01")!,
        UIImage(named: "circle_x_02")!,
        UIImage(named: "circle_x_03")!,
        UIImage(named: "circle_x_04")!,
        UIImage(named: "circle_x_05")!,
        UIImage(named: "circle_x_06")!,
        UIImage(named: "circle_x_07")!
    ];
    var reversedAnimationImages: [UIImage] { get { return reverse(animationImages) } }
    
    var hiddenStatusBar:Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    let dropdownTransitioningDelegate = DropdownTransitioningDelegate()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.alpha = 0
        
        dropdownButtonImage.animationImages = self.animationImages;
        dropdownButtonImage.animationDuration = Double(self.animationImages.count) / 50.0;
        dropdownButtonImage.animationRepeatCount = 1;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        dropdownVC = segue.destinationViewController as! DropdownViewController
        
        dropdownVC.modalPresentationStyle = .Custom
        dropdownVC.transitioningDelegate = dropdownTransitioningDelegate
        
        dropdownVC.dropdownPressed = {(index: Int) -> Void in
            self.hiddenStatusBar = false
        }
        
        hiddenStatusBar = false
        
        if segue.identifier == "embedSegue" {
            let childViewController = segue.destinationViewController as! DropdownViewController
            childViewController.delegate = self
        }
    }
    
    // MARK: - Transition Animations
    
    func show(completion: () -> Void) {
        dropdownButtonImage.animationImages = self.animationImages;
        dropdownButtonImage.image = dropdownButtonImage.animationImages?.last as? UIImage
        dropdownButtonImage.startAnimating()

        let delay = dropdownButtonImage.animationDuration * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
            self.dropdownButtonImage.stopAnimating()
        })
        
        var animationDuration = Double(self.animationMultiplier) * 1 / 2.5;
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.backgroundView.alpha = 1
        })
        
    }
    
    func hide(completion: () -> Void ) {
        dropdownButtonImage.animationImages = self.reversedAnimationImages
        dropdownButtonImage.image = dropdownButtonImage.animationImages?.last as? UIImage
        dropdownButtonImage.startAnimating()
        
        let delay = dropdownButtonImage.animationDuration * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
            self.dropdownButtonImage.stopAnimating()
        })
        
        var animationDuration = Double(self.animationMultiplier) * 1 / 2.5;
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.backgroundView.alpha = 0
        })
        
    }
    
    // MARK: - Actions
    
    @IBAction func buttonAction(sender: AnyObject) {
        dropdownVC.toggle()
        self.toggle()
    }
    
    func toggle() {
        if (isOpen) {
            hide { () -> () in
                false
            }
            isOpen = false
        } else {
            show { () -> () in
                false
            }
            isOpen = true
        }
    }
    
    // MARK: - DropDownViewControllerDelegate
    
    func dropDownViewControllerDidPressButton(viewController: DropdownViewController) {
        toggle()
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
