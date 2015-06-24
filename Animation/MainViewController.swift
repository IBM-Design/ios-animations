import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    Main menu of the sampler, providing buttons to get to any of the sample
    scenarios. There is no code related to the motion samples in this view
    controller.
*/

class MainViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var noteViewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noteViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Constants, Properties
    
    var noteViewHeight: CGFloat?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // only enable scrolling if there is enough content
        tableView.alwaysBounceVertical = false
    }
    
    // MARK: - Scroll View
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        
        let maxScrollOffset: CGFloat = 30
        let alphaPercentage = (150 - (scrollOffset * 10)) / 150 * 2
        
        if noteViewHeight == nil {
            noteViewHeight = noteViewHeightConstraint.constant
        }
        
        let offsetToShowNote: CGFloat = -20
        let offsetToHideNote: CGFloat = 15
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCellID") as! TableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        // Display text
        switch (indexPath.section, indexPath.row) {
            case (0, 0):
                cell.label.text = "Tab Bar"
            case (0, 1):
                cell.label.text = "Search"
            case (0, 2):
                cell.label.text = "Modal"
            case (0, 3):
                cell.label.text = "Dropdown"
            default:
                cell.label.text = ""
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Row selected, view storyboard by ID
        switch (indexPath.section, indexPath.row) {
            case (0, 0):
                showView("TabBar", viewControllerID: "TabBarControllerID")
            case (0, 1):
                showView("Search", viewControllerID: "SearchNavigationControllerID")
            case (0, 2):
                showView("Modal", viewControllerID: "ModalNavigationControllerID")
            case (0, 3):
                showView("Dropdown", viewControllerID: "DropdownViewControllerID")
            default:break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    // MARK: - Flow
    
    // The view controller is pushed in a different way depending if it's inside a 
    // navigation controller.
    func showView(storyboard: String, viewControllerID: String) {
        let sb = UIStoryboard(name: storyboard, bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier(viewControllerID) as! UIViewController
        
        if vc is UINavigationController {
            var nav = vc as! UINavigationController
            var view = nav.viewControllers.first as! UIViewController
            self.navigationController?.pushViewController(view, animated: true)
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // MARK: - Appearance
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}

