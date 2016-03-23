//
//  SubMenuController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 17.04.15.
//  Last modified on 23.03.16
//
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//
//

import UIKit

class SubMenuController: UITableViewController {
    
    var DEBUG: Bool = false
    // if (DEBUG) {}
    
    var items: NSArray = NSArray()
    
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = appDelegate.dict
        
        let label_settings_title: String = dict.objectForKey("labels")!.objectForKey("Submenu")!.objectForKey("settings_title") as! String
        let label_settings_subtitle: String = dict.objectForKey("labels")!.objectForKey("Submenu")!.objectForKey("settings_subtitle") as! String
        let label_help_title: String = dict.objectForKey("labels")!.objectForKey("Submenu")!.objectForKey("help_title") as! String
        let label_help_subtitle: String = dict.objectForKey("labels")!.objectForKey("Submenu")!.objectForKey("help_subtitle") as! String
        
        let settings_title = label_settings_title
        let settings_sub = label_settings_subtitle
        let help_title = label_help_title
        let help_sub = label_help_subtitle
        
        self.items = [  ["title": settings_title, "subtitle": settings_sub],
                        ["title": help_title, "subtitle": help_sub]
                        ]
            
        // Set Table Layout and cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Get rid of empty lines
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        // self.tableView.reloadData()
        
        let kfirstrun: Int? = userDefaults.objectForKey("firstRun") as! Int?
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        if (DEBUG) { print("DEBUG MSG SubMenuController_ : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup)") }
        
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
        
        if (DEBUG) { print(row) }
    }
    
}

        