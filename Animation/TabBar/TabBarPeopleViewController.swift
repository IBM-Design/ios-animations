import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

class TabBarPeopleViewController: ExampleNobelViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as! TableViewCell
        
        cell.smallLabel.text = ""
        
        return cell
        
    }

}
