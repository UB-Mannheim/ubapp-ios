//
//  ViewController.swift
//  SelfSizingDemo
//
//  Created by Simon Ng on 4/9/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit

class Help2ViewController: UITableViewController {
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
    
    
    var hotelNames:[String] = []
    
    var items = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        hotelNames = [String](hotels.keys)
        
        self.items = [  ["image": "website_bk", "title": "Website", "descr": "Öffnet die mobile Version der UB-Homepage mit umfassenden Informationen rund um die Bibliothek"],
            ["image": "primo_bk", "title": "Primo", "descr": "In der mobilen Version des Online-Katalogs Primo der UB-Mannheim stehen Ihnen alle bekannten Funktionalitäten wie Recherche, Ausleihe, Fernleihe und die Kontofunktionen zur Verfügung."],
            ["image": "news_bk", "title": "News", "descr": "Anzeige der letzten 5 Meldungen asu dem Aktuelles-Weblog der UB-Mannheim. Die Anzahl der angezeigten Einträge kann über das Menü Einstellungen verändert werden."],
            ["image": "seats_bk", "title": "Freie Plätze", "descr": "Ein Ampelsystem informiert über die Verfügbarkeit von Arbeitsplätzen in den einzelnen Bibliotheksbereichen."],
            ["image": "config_bk", "title": "Einstellungen", "descr": "Bietet Möglichkeiten zur Personlisierung der UB-App. \n\nDaten Cache \nDie Aktivierung der Cache-Funktion erzeugt eine Datenbank zur lokalen Speicherung der zuletzt heruntergeladenen Daten der Funktionen \"News\" und \"Freie Plätze\". Die gespeicherten Daten werden angezeigt, sobald kein Internet Zugriff zuer Verfügung steht. Die Deaktivierung des Daten-Caches löscht die angelegte Datenbank. In der Standardeinstellung ist die Cache-Funktion deaktiviert, d.h. es existiert kein Zwischenspeicher und alle Daten müssen online abgerufen werden. \n\nAngezeigte News-Einträge \nLegen Sie fest, wie viele Beiträge aus dem Aktuelles-Weblog unter \"News\" angezeigt werden:\n5 (Standardeinstellung), 10, oder 15 \n\nStarte UB-App mit\nWählen Sie ihre oersönliche Startfunktion der UB-App:\nStarmenü (Standardeinstellung), Website, Primo, News und Freie Plätze."]
        ]
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
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
        
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! UITableViewCell
        
        headerCell.textLabel?.text = "FAQ"
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

