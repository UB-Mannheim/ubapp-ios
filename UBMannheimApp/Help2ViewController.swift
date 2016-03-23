//
//  ViewController.swift
//  SelfSizingDemo
//
//  Created by Simon Ng on 4/9/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//
//  Last modified on 23.03.2016 by Alexander Wagner
//
//

import UIKit

class Help2ViewController: UITableViewController {
    
    var DEBUG: Bool = false
    // if (DEBUG) {
    
    var hotelNames:[String] = []
    
    var items = []
    
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = appDelegate.dict
        
        let website_title: String = dict.objectForKey("labels")!.objectForKey("Help")!.objectForKey("website_title") as! String
        let website_sub: String = dict.objectForKey("labels")!.objectForKey("Help")!.objectForKey("website_subtitle") as! String
        let primo_title: String = dict.objectForKey("labels")!.objectForKey("Help")!.objectForKey("primo_title") as! String
        let primo_sub: String = dict.objectForKey("labels")!.objectForKey("Help")!.objectForKey("primo_subtitle") as! String
        let news_title: String = dict.objectForKey("labels")!.objectForKey("Help")!.objectForKey("news_title") as! String
        let news_sub: String = dict.objectForKey("labels")!.objectForKey("Help")!.objectForKey("news_subtitle") as! String
        let seats_title: String = dict.objectForKey("labels")!.objectForKey("Help")!.objectForKey("seats_title") as! String
        let seats_sub: String = dict.objectForKey("labels")!.objectForKey("Help")!.objectForKey("seats_subtitle") as! String
        let config_title: String = dict.objectForKey("labels")!.objectForKey("Help")!.objectForKey("config_title") as! String
        let config_sub: String = dict.objectForKey("labels")!.objectForKey("Help")!.objectForKey("config_subtitle") as! String
        
        self.items = [  ["image": "website_bk", "title": website_title, "descr": website_sub],
            ["image": "primo_bk", "title": primo_title, "descr": primo_sub],
            ["image": "news_bk", "title": news_title, "descr": news_sub],
            ["image": "seats_bk", "title": seats_title, "descr": seats_sub],
            ["image": "config_bk", "title": config_title, "descr": config_sub]
        ]
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        let kfirstrun: Int? = userDefaults.objectForKey("firstRun") as! Int?
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        if (DEBUG) { print("DEBUG MSG HelpViewController_: FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup)") }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return hotels.count
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CustomTableViewCell
        
        let title = self.items[indexPath.row]["title"] as! String
        let subtitle = self.items[indexPath.row]["descr"] as! String
        
        cell.nameLabel?.text = title as String?
        cell.addressLabel?.text = subtitle as String?
        cell.imageView!.image = UIImage(named: self.items[indexPath.row]["image"] as! String)
        
        return cell
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell")! as UITableViewCell
        
        let dict = appDelegate.dict
        let help_title: String = dict.objectForKey("labels")!.objectForKey("Help")!.objectForKey("help_title") as! String
        
        headerCell.textLabel?.text = help_title
        headerCell.backgroundColor = uicolorFromHex(0xf7f7f7)
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
}

