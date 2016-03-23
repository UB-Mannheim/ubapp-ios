//
//  HelpViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 16.04.15.
//  Last modified on 23.03.16
//
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//
//  STATUS: INACTIVE
//
//

import UIKit

class HelpViewController: UITableViewController {
  
    // FixMe
    // That's the old HelpController and should be deleted!
    
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
        
        
        
        let title = self.items[indexPath.row]["title"] as! String
        let subtitle = self.items[indexPath.row]["descr"] as! String
        
        cell.textLabel?.text = title
        // cell.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.detailTextLabel?.text = subtitle
        // cell.detailTextLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        cell.detailTextLabel?.numberOfLines = 0
        
        cell.imageView?.image = UIImage(named: self.items[indexPath.row]["image"] as! String)
        
        print(title)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
}