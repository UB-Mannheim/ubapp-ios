//
//  SubMenuController.swift
//  UBMannheimApp
//
//  Created by Universitätsbibliothek Mannheim on 17.04.15.
//  Last modified on 23.03.16
//
//  Copyright (c) 2015 Universitätsbibliothek Mannheim. All rights reserved.
//
//

import UIKit

class SubMenuController: UITableViewController {
    
    var DEBUG: Bool = false
    // if (DEBUG) {}
    
    // var items: NSArray = NSArray()
    var items: [[String: String]] = []
    
    let userDefaults:UserDefaults=UserDefaults.standard
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = appDelegate.dict
        
        let label_settings_title: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Submenu")! as AnyObject).object(forKey: "settings_title") as! String
        let label_settings_subtitle: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Submenu")! as AnyObject).object(forKey: "settings_subtitle") as! String
        let label_help_title: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Submenu")! as AnyObject).object(forKey: "help_title") as! String
        let label_help_subtitle: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Submenu")! as AnyObject).object(forKey: "help_subtitle") as! String
        
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
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Get rid of empty lines
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // self.tableView.reloadData()
        
        let kfirstrun: Int? = userDefaults.object(forKey: "firstRun") as! Int?
        let kcache: Bool? = userDefaults.object(forKey: "cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.object(forKey: "newsCount") as! Int?
        let kstartup: Int? = userDefaults.object(forKey: "startupWith") as! Int?
        if (DEBUG) {
            print("DEBUG MSG SubMenuController_ : FirstRun = \((kfirstrun?.description)!) | Cache = \((kcache?.description)!) | News = \((knews?.description)!) | Startup \((kstartup?.description)!)")
            }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        // let title = self.items[indexPath.row]["title"]
        // let elements: NSArray = self.items[indexPath.row] as! NSArray
        // let title: NSString = elements[0] as! NSString
        // let subtitle = self.items[indexPath.row]["subtitle"] as! NSString
        // let subtitle: NSString = elements[1] as! NSString
        
        let elements = self.items[indexPath.row]
        let title: String = (elements["title"])!
        let subtitle: String = (elements["subtitle"])!
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        
        if ( row==0 ) {
        performSegue(withIdentifier: "showNewConfig", sender: self)
        }
        
        if ( row==1 ) {
            performSegue(withIdentifier: "showHelp2", sender: self)
        }
        
        if (DEBUG) { print(row) }
    }
    
}

        
