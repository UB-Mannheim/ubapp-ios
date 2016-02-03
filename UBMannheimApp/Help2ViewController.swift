//
//  ViewController.swift
//  SelfSizingDemo
//
//  Created by Simon Ng on 4/9/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit

class Help2ViewController: UITableViewController {
    
    // PLEASE CLEAN UP HOTELS
    
    var DEBUG: Bool = false
    // if (DEBUG) {
    
    /*
    var hotels:[String: String] = ["The Grand Del Mar": "5300 Grand Del Mar Court, San Diego, CA 92130",
        "French Quarter Inn": "166 Church St, Charleston, SC 29401",
        "Bardessono": "6526 Yount Street, Yountville, CA 94599",
        "Hotel Yountville": "6462 Washington Street, Yountville, CA 94599",
        "Islington Hotel": "321 Davey Street, Hobart, Tasmania 7000, Australia",
        "The Henry Jones Art Hotel": "25 Hunter Street, Hobart, Tasmania 7000, Australia",
        "Clarion Hotel City Park Grand": "22 Tamar Street, Launceston, Tasmania 7250, Australia",
        "Quality Hotel Colonial Launceston": "31 Elizabeth St, Launceston, Tasmania 7250, Australia",
        "Premier Inn Swansea Waterfront": "Waterfront Development, Langdon Rd, Swansea SA1 8PL, Wales",
        "Hatcher's Manor": "73 Prossers Road, Richmond, Clarence, Tasmania 7025, Australia"]
    */
    
    var hotelNames:[String] = []
    
    var items = []
    
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // var preferredLanguage = NSLocale.preferredLanguages()[0] as String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        /*
        var website_title = "Website"
        var website_sub = "Opens up the mobile view of our website, containing comprehensive information about the university library."
        var primo_title = "Primo"
        var primo_sub = "With the mobile view of our library catalogue, you can use all common functions that are available in the classic view: search, (interlibray) loan and managing your account information."
        var news_title = "News"
        var news_sub = "Showing the 5 latest posts from our blog. The count number can be set in the configuration menu."
        var seats_title = "Free Seats"
        var seats_sub = "A traffic light system informing about the load and availibility of free seats in the different library sections."
        var config_title = "Settings"
        var config_sub = "Additionally the following settings can be changed \n\nThe activation of the cache function creates a database for local storage of the most recently downloaded data for the \"News\" and \"Free Seats\". The stored data is displayed when no Internet access is available. Disabling this function will delete the created database. By default, caching is disabled, in this case all data must be accessed online. \n\nDetermine how many posts from the news-blog \"News\" is displayed: 5 (Default), 10 and 15 \n\nSelect your personal startup function: Startmenü (Default) , Website, Primo, News, Free Seats\n\nAn integrated Help completes the app."
        
        if (preferredLanguage == "de") {
        
          website_title = "Website"
          website_sub = "Öffnet die mobile Version der UB-Homepage mit umfassenden Informationen rund um die Bibliothek."
          primo_title = "Primo"
          primo_sub = "In der mobilen Version des Online-Katalogs Primo der UB-Mannheim stehen Ihnen alle bekannten Funktionalitäten wie Recherche, Ausleihe, Fernleihe und die Kontofunktionen zur Verfügung."
          news_title = "News"
          news_sub = "Anzeige der letzten 5 Meldungen aus dem Aktuelles-Weblog der UB-Mannheim. Die Anzahl der angezeigten Einträge kann über das Menü Einstellungen verändert werden."
          seats_title = "Freie Plätze"
          seats_sub = "Ein Ampelsystem informiert über die Verfügbarkeit von Arbeitsplätzen in den einzelnen Bibliotheksbereichen."
          config_title = "Einstellungen"
          config_sub = "Bietet Möglichkeiten zur Personalisierung der UB-App. \n\nDaten Cache \nDie Aktivierung der Cache-Funktion erzeugt eine Datenbank zur lokalen Speicherung der zuletzt heruntergeladenen Daten der Funktionen \"News\" und \"Freie Plätze\". Die gespeicherten Daten werden angezeigt, sobald kein Internet-Zugriff zur Verfügung steht. Die Deaktivierung des Daten-Caches löscht die angelegte Datenbank. In der Standardeinstellung ist die Cache-Funktion deaktiviert, d.h. es existiert kein Zwischenspeicher und alle Daten müssen online abgerufen werden. \n\nAngezeigte News-Einträge \nLegen Sie fest, wie viele Beiträge aus dem Aktuelles-Weblog unter \"News\" angezeigt werden:\n5 (Standardeinstellung), 10 oder 15. \n\nStarte UB-App mit\nWählen Sie ihre persönliche Startfunktion der UB-App:\nStartmenü (Standardeinstellung), Website, Primo, News und Freie Plätze."
            
        }
        */
        
        // hotelNames = [String](hotels.keys)
        
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
    
    //    override func viewDidAppear(animated: Bool) {
    //
    //        tableView.reloadData()
    //
    //    }
    
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
        // cell.cellImage?.image = UIImage(named: self.items[indexPath.row]["image"] as! String)
        cell.imageView!.image = UIImage(named: self.items[indexPath.row]["image"] as! String)
        
        /*
        let hotelName = hotelNames[indexPath.row]
        cell.nameLabel.text = hotelName
        cell.addressLabel.text = hotels[hotelName]
        */
        
        return cell
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // http://www.ioscreator.com/tutorials/customizing-header-footer-table-view-ios8-swift
        
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell")! as UITableViewCell
        
        let dict = appDelegate.dict
        let help_title: String = dict.objectForKey("labels")!.objectForKey("Help")!.objectForKey("help_title") as! String
        
        headerCell.textLabel?.text = help_title
        headerCell.backgroundColor = uicolorFromHex(0xf7f7f7)
        /*
        switch (section) {
        case 0:
            headerCell.headerLabel.text = "Europe";
            //return sectionHeaderView
        case 1:
            headerCell.headerLabel.text = "Asia";
            //return sectionHeaderView
        case 2:
            headerCell.headerLabel.text = "South America";
            //return sectionHeaderView
        default:
            headerCell.headerLabel.text = "Other";
        }
        */
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
}

