import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

class TableView: UITableView {
    
    var cellID: String {
        return "TableViewCellID"
    }
    
    override func awakeFromNib() {
        registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCellID")
        
        registerNib(UINib(nibName: "TableViewHeaderCell", bundle: nil), forCellReuseIdentifier: "TableViewHeaderCellID")
        
        self.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
}
