//
//  SeatsViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 27.01.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit
import Alamofire

// extend class https://www.weheartswift.com/how-to-make-a-simple-table-view-with-ios-8-and-swift/

// custom header http://www.ioscreator.com/tutorials/customizing-header-footer-table-view-ios8-swift

class SeatsViewController: UITableViewController {

    var dataset: [[String]] = [[]]
    var data = NSMutableData()
    var result = NSArray()
    
    var ids: [String] = []
    var names: [String] = []
    var percent: [Int] = []
    var max: [Int] = []
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSections()
        
        //self.tableView.rowHeight = 70
        // self.dataset = setTableData()
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

    func loadSections() {
        Alamofire.request(.GET, "http://www.bib.uni-mannheim.de/bereichsauslastung/index.php?json")
            .responseSwiftyJSON {(request, response, jsonObj, error) in
                for index in 0...jsonObj.count-1 {
                    self.names.append(jsonObj["sections"][index]["names"].stringValue)
                    self.ids.append(jsonObj["sections"][index]["ids"].stringValue)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView!.reloadData()
                })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setTableData() -> [[String]] {

        // Arrays in Swift
        // https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html
    
        var ic: [String] = ["Info-Center", "23"]
        var lc: [String] = ["Learning-Center", "17"]
        var eo: [String] = ["Ehrenhof (Hasso-Plattner-Bibliothek)", "64"]
        var bwl: [String] = ["BWL", "32"]
        var a3: [String] = ["Bereich A3", "83"]
        var a5: [String] = ["Bereich A5", "52"]
        
        var sections = [ic, lc, eo, bwl, a3, a5]
        
        return sections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.names[indexPath.row]
        cell.detailTextLabel?.text = self.ids[indexPath.row]
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }

}

