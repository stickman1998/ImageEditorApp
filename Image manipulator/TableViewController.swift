//
//  TableViewController.swift
//  Image manipulator
//
//  Created by Lee Bachman on 6/6/17.
//  Copyright © 2017 LeviLevi. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let filters = [
        "Red",
        "Green",
        "Blue",
        "Yellow",
        "Purple"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = filters[indexPath.row]
        
        return cell
    }

}
