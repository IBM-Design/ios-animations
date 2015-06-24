import UIKit

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
This licensed material is licensed under the Apache 2.0 license. http://www.apache.org/licenses/LICENSE-2.0.
*/

/**
    This class exists to serve as a base view controller for some of the
    samples. It does not contain any animation sample code, but provides a
    UITableView populated with placeholder data for visual effect.
*/

class ExampleNobelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Constants, Properties
    
    var nobelsAlphabetically: NSArray?
    var nobelsByDiscipline: NSArray?
    var nobels: NSArray?
    var filteredNobels: NSMutableArray?
    var filters: [Bool] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData() {
        let bundle = NSBundle.mainBundle()
        var error:NSError?
        
        let path1 = bundle.pathForResource("nobels_alphabetically", ofType: "json")
        var data1:NSData = NSData(contentsOfFile: path1!)!
        let json1:AnyObject = NSJSONSerialization.JSONObjectWithData(data1, options: NSJSONReadingOptions.AllowFragments, error:&error)!
        
        nobelsAlphabetically = json1 as? NSArray
      
        let path2 = bundle.pathForResource("nobels_by_discipline", ofType: "json")
        var data2:NSData = NSData(contentsOfFile: path2!)!
        let json2:AnyObject = NSJSONSerialization.JSONObjectWithData(data2, options: NSJSONReadingOptions.AllowFragments, error:&error)!
        
        nobelsByDiscipline = json2 as? NSArray
        
        filters = [true, true, true, true]
        
        sortAlphabetically()
    }
    
    // MARK: - Data Manipulation
    
    func sortAlphabetically() {
        nobels = nobelsAlphabetically
        updateFilters()
    }
    
    func sortByDiscipline() {
        nobels = nobelsByDiscipline
        updateFilters()
    }
    
    func updateFilters() {
        
        filteredNobels = NSMutableArray()
        
        if let nobels = nobels {
            
            for index in 0...nobels.count - 1 {
                
                if let section = nobels.objectAtIndex(index) as? NSDictionary {
                    
                    let array = section["Data"] as? NSArray
                    
                    var nobel_dict = NSMutableDictionary()
                    
                    nobel_dict["Section"] = section["Section"]
                    
                    var nobel_array = NSMutableArray()
                    
                    if let array = array {
                        
                        for nobel_index in 0...array.count - 1 {
                            
                            let person_dict = array[nobel_index] as? NSDictionary
                            
                            if let person_dict = person_dict {
                                
                                let discipline = person_dict["Discipline"] as? String
                                
                                if let discipline = discipline {
                                    if filters[0] && discipline == "Chemistry" {
                                        nobel_array.addObject(array[nobel_index])
                                    }
                                    else if filters[1] && discipline == "Economics" {
                                        nobel_array.addObject(array[nobel_index])
                                    }
                                    else if filters[2] && discipline == "Literature" {
                                        nobel_array.addObject(array[nobel_index])
                                    }
                                    else if filters[3] && discipline == "Medicine" {
                                        nobel_array.addObject(array[nobel_index])
                                    }
                                }
                            }
                            
                        }
                        
                    }
                    
                    nobel_dict["Data"] = nobel_array
                    
                    filteredNobels?.addObject(nobel_dict)

                }
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let nobels = filteredNobels {
            return nobels.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let nobels = filteredNobels {
            return (nobels[section]["Data"] as! NSArray).count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let table = tableView as! TableView
        let cell = tableView.dequeueReusableCellWithIdentifier(table.cellID, forIndexPath: indexPath) as! TableViewCell
        
        if let nobels = filteredNobels {
            let person = (nobels[indexPath.section]["Data"] as! NSArray)[indexPath.row] as? NSDictionary
            if let person = person {
                
                let lastName = person["Last name"] as! String
                let firstName = person["First name"] as! String
                
                cell.label.text = "\(lastName), \(firstName)"
                
                cell.smallLabel.text = person["Discipline"] as? String
                
            }
        }
    
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }

    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewHeaderCellID") as! TableViewHeaderCell
        if let nobels = filteredNobels {
            cell.label.text = nobels[section]["Section"] as? String
        }
        return cell
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}
