//
//  ViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 27.01.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

// extend class https://www.weheartswift.com/how-to-make-a-simple-table-view-with-ios-8-and-swift/

// custom header http://www.ioscreator.com/tutorials/customizing-header-footer-table-view-ios8-swift

class SeatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet
    var tableView: UITableView!
    // var dataset: [String] = ["Ehrenhof", "BWL", "A3"]
    var dataset: [[String]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        
        self.dataset = setTableData()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setTableData() -> [[String]] {

        // Arrays in Swift
        // https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/CollectionTypes.html
        
        var ic: [String] = ["Info-Center", "23"]
        // var ic = ["Info-Center", "23"]
        var lc: [String] = ["Learning-Center", "17"]
        var eo: [String] = ["Ehrenhof (Hasso-Plattner-Bibliothek)", "64"]
        var bwl: [String] = ["BWL", "32"]
        var a3: [String] = ["Bereich A3", "83"]
        var a5: [String] = ["Bereich A5", "52"]
        
        var sections = [ic, lc, eo, bwl, a3, a5]

        return sections
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataset.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        var value:Int? = self.dataset[indexPath.row][1].toInt()
        
        cell.textLabel?.text = self.dataset[indexPath.row][0] + " (" + self.dataset[indexPath.row][1] + " %)"
        
        
        if(value < 30) {
            cell.imageView?.image = UIImage (named: "sign_green.png")
            }
        if(value >= 30) {
            cell.imageView?.image = UIImage (named: "sign_yellow.png")
        }
        if(value > 60) {
            cell.imageView?.image = UIImage (named: "sign_red.png")
        }
        
        return cell
    
        // return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }

}

