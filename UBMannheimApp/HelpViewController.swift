//
//  HelpViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 16.04.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//
import UIKit

class HelpViewController: UITableViewController, UITableViewDataSource {
  
    // OLD HELP CONTROLLER, SHOULD BE DELETED
    
    var items = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.items = [  ["image": "website_bk", "title": "Website", "descr": "Öffnet die mobile Version der UB-Homepage mit umfassenden Informationen rund um die Bibliothek"],
                        ["image": "primo_bk", "title": "Primo", "descr": "In der mobilen Version des Online-Katalogs Primo der UB-Mannheim stehen Ihnen alle bekannten Funktionalitäten wie Recherche, Ausleihe, Fernleihe und die Kontofunktionen zur Verfügung."],
                        ["image": "news_bk", "title": "News", "descr": "Anzeige der letzten 5 Meldungen asu dem Aktuelles-Weblog der UB-Mannheim. Die Anzahl der angezeigten Einträge kann über das Menü Einstellungen verändert werden."],
                        ["image": "seats_bk", "title": "Freie Plätze", "descr": "Ein Ampelsystem informiert über die Verfügbarkeit von Arbeitsplätzen in den einzelnen Bibliotheksbereichen."],
                        ["image": "config_bk", "title": "Einstellungen", "descr": "Bietet Möglichkeiten zur Personlisierung der UB-App. \n\n Daten Cache \n Die Aktivierung der Cache-Funktion erzeugt eine Datenbank zur lokalen Speicherung der zuletzt heruntergeladenen Daten der Funktionen \"News\" und \"Freie Plätze\". Die gespeicherten Daten werden angezeigt, sobald kein Internet Zugriff zuer Verfügung steht. Die Deaktivierung des Daten-Caches löscht die angelegte Datenbank. In der Standardeinstellung ist die Cache-Funktion deaktiviert, d.h. es existiert kein Zwischenspeicher und alle Daten müssen online abgerufen werden. \n\n Angezeigte News-Einträge \n Legen Sie fest, wie viele Beiträge aus dem Aktuelles-Weblog unter \"News\" angezeigt werden:\n 5 (Standardeinstellung), 10, oder 15 \n\n Starte UB-App mit\n Wählen Sie ihre oersönliche Startfunktion der UB-App:\n Starmenü (Standardeinstellung), Website, Primo, News und Freie Plätze."]
                    ]
        
        
        // self.tableView.rowHeight = 70
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // get rid of empty lines
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        

        // tableView.estimatedRowHeight = 70
        // tableView.rowHeight = UITableViewAutomaticDimension
        
        // http://coding.tabasoft.it/ios/ios8-self-sizing-uitableview-cells/
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        // tableView.reloadData()
        
        
        // last try multiple heights of rows
        // http://www.toptensoftware.com/xibfree/uitableviewcell_variable
    
    
        //possibly here:
        // http://www.appcoda.com/self-sizing-cells/
        // DROPBOX!!!
        
    }
    
    
    
    /*
    func preferredFontChanged(notif : NSNotification) {
        
        tableView.reloadData()
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        /*
        // http://www.ioscreator.com/tutorials/customizing-header-footer-table-view-ios8-swift
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        */
        
        let title = self.items[indexPath.row]["title"] as! String
        let subtitle = self.items[indexPath.row]["descr"] as! String
        
        cell.textLabel?.text = title
        // cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.detailTextLabel?.text = subtitle
        // cell.detailTextLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        cell.detailTextLabel?.numberOfLines = 0
        
        cell.imageView?.image = UIImage(named: self.items[indexPath.row]["image"] as! String)
        
        /*
        // http://stackoverflow.com/questions/25947146/multiple-uilabels-inside-a-self-sizing-uitableviewcell
    
        cell.bounds = CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.bounds), height: 99999)
        cell.contentView.bounds = cell.bounds
        cell.layoutIfNeeded()
        
        cell.textLabel?.preferredMaxLayoutWidth = CGRectGetWidth(cell.textLabel!.frame)
        // cell.detailTextLabel?.preferredMaxLayoutWidth = CGRectGetWidth(cell.detailTextLabel!.frame)
        */
        println(title)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    /*
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // CUSTOM HEADER
        
        // http://stackoverflow.com/questions/27879986/make-button-in-tableview-section-header-float-align-right-programmatically-sw
        // constraints in code s.u.
        
        
        var headerFrame = tableView.frame
        
        var headerView:UIView = UIView(frame: CGRectMake(0, 0, headerFrame.size.width, headerFrame.size.width))
        headerView.backgroundColor = UIColor.grayColor()
        
        var title = UILabel()
        title.setTranslatesAutoresizingMaskIntoConstraints(false)
        title.font = UIFont.boldSystemFontOfSize(20.0)
        title.text = "FAQ"
        title.textColor = UIColor.whiteColor()
        headerView.addSubview(title)
        
        
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["title"] = title
        // viewsDict["headBttn"] = headBttn
        
        headerView.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|-0-[title]-0-|", options: nil, metrics: nil, views: viewsDict))
        
        // headerView.addConstraints(
        //    NSLayoutConstraint.constraintsWithVisualFormat(
        //        "H:|-10-[title]-[headBttn]-15-|", options: nil, metrics: nil, views: viewsDict))
        
        // headerView.addConstraints(
        //    NSLayoutConstraint.constraintsWithVisualFormat(
        //        "V:|-[title]-|", options: nil, metrics: nil, views: viewsDict))
        
        // headerView.addConstraints(
        //    NSLayoutConstraint.constraintsWithVisualFormat(
        //        "V:|-[headBttn]-|", options: nil, metrics: nil, views: viewsDict))
        
        return headerView
    }
    */
}