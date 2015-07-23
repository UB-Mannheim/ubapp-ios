//
//  SubMenuController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 17.04.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

class SubMenuController: UITableViewController, UITableViewDelegate {
    
    var DEBUG: Bool = false
    // if (DEBUG) {
    
    var items: NSArray = NSArray()
    
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.items = [  ["title": "Einstellungen", "subtitle": "(Personalisieren Sie Ihre App)"],
                        ["title": "Hilfe", "subtitle": "(Hier finden Sie nützliche Tipps zur Bedienung der App)"]
                        ]
        // Cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // get rid of empty lines
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // self.tableView.reloadData()
        
        
        /*
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("startupWith") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("newsCount") as! Int?
        
        if (DEBUG) { println("\(kcache) :: \(kstartup) :: \(knews)") }
        */
        let kfirstrun: Int? = userDefaults.objectForKey("firstRun") as! Int?
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        if (DEBUG) { println("DEBUG MSG SubMenuController_ : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup)") }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        let title = self.items[indexPath.row]["title"] as! String
        let subtitle = self.items[indexPath.row]["subtitle"] as! String
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        
        
        if(title.isEqual("Einstellungen")) {
            cell.imageView?.image = UIImage(named: "gear-7_iconbeast")
        }
        if(title.isEqual("Hilfe")) {
            cell.imageView?.image = UIImage(named: "book-simple-7_iconbeast")
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
        if ( row==0 ) {
        performSegueWithIdentifier("showNewConfig", sender: self)
        }
        
        if ( row==1 ) {
            performSegueWithIdentifier("showHelp2", sender: self)
        }
        
        // if (DEBUG) { println(row) }
    }
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        
        /*
        var sizeRect = UIScreen.mainScreen().applicationFrame;
        var width = sizeRect.size.width;
        var height = sizeRect.size.height;
        */
        /*
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth: CGFloat = screenSize.width
        let screenHeight: CGFloat = screenSize.height
        
        // configButton.titleLabel!.font = UIFont(name: "Helvetica", size: screenWidth/10)
        configButton.titleLabel!.font = UIFont.systemFontOfSize(screenHeight/25)
        configButton.titleLabel!.frame = CGRectOffset(configButton.titleLabel!.frame, 40, 40);
        configButton.titleLabel!.textAlignment = .Left
        // configButton.titleLabel!.textColor = UIColor.whiteColor()
        
        helpButton.titleLabel!.font = UIFont(name: "Helvetica", size: screenHeight/25)
        helpButton.titleLabel!.textAlignment = .Left
        */
        
        /*
        let IS_IPHONE5 = fabs(UIScreen.mainScreen().bounds.size.height-568) < 1;
        
        let IS_IPAD = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad);
        
        let IS_IOS8 = (UIDevice.currentDevice().systemVersion.floatValue >= 8)
        
        let APP_DEFAULT_FONT_FACE_NAME = "HelveticaNeue-Light";
        
        let APP_DEFAULT_FONT_FACE_THIN_NAME = "HelveticaNeue-UltraLight";
        */
    }

    */
}

        