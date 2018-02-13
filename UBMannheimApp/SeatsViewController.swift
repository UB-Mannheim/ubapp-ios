//
//  SeatsViewController.swift
//  UBMannheimApp
//
//  Created by Universitätsbibliothek Mannheim on 27.01.15.
//  Copyright (c) 2015 Universitätsbibliothek Mannheim. All rights reserved.
//

import UIKit
// import Alamofire

// extend class https://www.weheartswift.com/how-to-make-a-simple-table-view-with-ios-8-and-swift/

// custom header http://www.ioscreator.com/tutorials/customizing-header-footer-table-view-ios8-swift


var api = JsonAPI()


class SeatsViewController: UITableViewController {

    
    var dataset: [[String]] = [[]]
    var data = NSMutableData()
    var result = NSArray()
    
    var ids: [String] = []
    var names = NSArray()
    // var percent: [Int] = []
    // var max: [Int] = []
    
    var items: NSMutableArray = []
    
    /*
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView = UITableView(frame:self.view!.frame)
        //self.tableView!.delegate = self
        //self.tableView!.dataSource = self
        //self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // loadSections()
        
        self.tableView.rowHeight = 70
        self.dataset = setTableData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        /*
        api.getData({data, error -> Void in
            if (data != nil) {
                self.items = NSMutableArray(array: data)
                self.tableView!.reloadData()            } else {
                print("api.getData failed")
                print(error)
            }
        })
        */

    }
    
    /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]["bereiche"] as? NSString
        cell.detailTextLabel?.text = self.items[indexPath.row]["bereiche"] as? NSString
        return cell
        
    }
    */

    /*
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
    

    */
    func setTableData() -> [[String]] {

        // Arrays in Swift
        // https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html
    
        let ic: [String] = ["Info-Center", "23"]
        let lc: [String] = ["Learning-Center", "17"]
        let eo: [String] = ["Ehrenhof (Hasso-Plattner-Bibliothek)", "64"]
        let bwl: [String] = ["BWL", "32"]
        let a3: [String] = ["Bereich A3", "83"]
        let a5: [String] = ["Bereich A5", "52"]
        
        let sections = [ic, lc, eo, bwl, a3, a5]
        
        self.names = sections as NSArray
        
        return sections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        
        cell.textLabel?.text = self.names[indexPath.row] as? String
        cell.detailTextLabel?.text = self.ids[indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }

}

