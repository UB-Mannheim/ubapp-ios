//
//  FeedTableViewController.swift
//  RSSwift
//
//  Created by Arled Kola on 20/09/2014.
//  Copyright (c) 2014 Arled. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, NSXMLParserDelegate {

    var DEBUG: Bool = false
    
    var myFeed : NSArray = []
    var url: NSURL = NSURL()
    
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    var news_feed : Int = 5
    var news_cache: [[String]] = []
    var news_rss_items = 0
    
    // UIRefreshControl
    func refresh(sender:AnyObject)
    {
        if (DEBUG) { print("refresh::start") }
        
        if IJReachability.isConnectedToNetwork() {
            
            
        // PRUEFEN:
            // ANZAHL DER NEWS BEI AKTIVEM NETZ
            // EINSCHRAENKUNG EINHALTEN Test Isa: 5 < 7
            
        // Updating your data here...
        loadRss(url)
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        
        } else {
            
            let alertController = UIAlertController(title: "Fehler", message: "Keine Verbindung zum Netzwerk vorhanden. Aktualisierung der Daten nicht möglich. Bitte probieren Sie es später noch einmal.", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.viewDidLoad()
            }
            
            alertController.addAction(okAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            self.refreshControl?.endRefreshing()
        }
        
    }

    override func viewDidLoad() {
        
        if (DEBUG) { print("didLoad::start") }
        
        super.viewDidLoad()

        let news_entries = userDefaults.objectForKey("newsCount") as! Int?
        if (news_entries != nil) {
            switch(news_entries as Int!) {
            case 0: news_feed = 5
            case 1: news_feed = 10
            case 2: news_feed = 15
            default: news_feed = 15
            }
        }
        
        let kfirstrun: Int? = userDefaults.objectForKey("firstRun") as! Int?
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        
        if (DEBUG) { print("DEBUG MSG FeedTabVController : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup) [@Info: showing \(news_feed) Entries]") }
        
        // if pulled down, refresh
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        // Cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // get rid of empty lines
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        
        // Set feed url. http://www.formula1.com/rss/news/latest.rss
        // url = NSURL(string: "http://www.skysports.com/rss/0,20514,11661,00.xml")!
        url = NSURL(string: "http://blog.bib.uni-mannheim.de/Aktuelles/?feed=rss2&cat=4")!
        
        // if Network Connection online
        if IJReachability.isConnectedToNetwork() {
            
            if (DEBUG) { print("connected") }
            
            var news_rssdata: AnyObject = loadRss(url)
            news_rss_items = news_rssdata.count
            if (DEBUG) { print("news rss data count: \(news_rss_items)") }
            
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            
            //  if Cache on
            if(userDefaults.objectForKey("cacheEnabled")?.boolValue == true) {
              
            // if (DEBUG) { print("Cache on ....................................................") }
                //  update Cache Entries
                var maxnews_count = userDefaults.objectForKey("newsCount") as! Int
                
                ////////
                // ERROR maxnews_count >> picker_select(0,1,2) != count(5,10,15)
                ////////
                
                switch(maxnews_count) {
                case 0: maxnews_count = 5
                    break
                case 1: maxnews_count = 10
                    break
                case 2: maxnews_count = 15
                    break
                default: maxnews_count = 5 // ? s.u. 0
                }
                
                // if (DEBUG) { print("maxnews_count \(maxnews_count) ....................................................") }
                
                // if (DEBUG) { print("NEWS COUNT") }
                // if (DEBUG) { print(news_rssdata.count) }
                
                
                if(news_rssdata.count < maxnews_count) {
                    maxnews_count = news_rssdata.count
                }
                
                // if (DEBUG) { print("maxnews_count = \(maxnews_count)") }
                var news_item = ["", "", "", "", ""]
                
                for (var i = 0; i < maxnews_count; i++) {
                    
                    // if (DEBUG) { print("row per row ....................................................") }
                    // if (DEBUG) { print("News mit ID=\(i) \(news_rssdata[i])") TMP s.o. voher ausgabe der news, aus debugzwecken ausgeklammert }
                    
                    news_item[0] = news_rssdata[i].objectForKey("title") as! String
                    news_item[1] = news_rssdata[i].objectForKey("description") as! String
                    news_item[2] = news_rssdata[i].objectForKey("content:encoded") as! String
                    news_item[3] = news_rssdata[i].objectForKey("pubDate") as! String
                    news_item[4] = news_rssdata[i].objectForKey("link") as! String
                 
                    self.news_cache.append(news_item)
                }
                
                userDefaults.setObject(self.news_cache, forKey: "newsCache")
                userDefaults.synchronize()
                
                let newsentries: AnyObject = userDefaults.objectForKey("newsCache")!
                if (DEBUG) { print("freshly filled preference: \(newsentries)") }
            }
            
            
        } else {
            
            if (DEBUG) { print("No Network available") }
            
            
            // if Cache on
            if ( (userDefaults.objectForKey("cacheEnabled")?.boolValue == true) ) { // && (userDefaults.objectForKey("newsCache") != nil) ) {
            
            
                
                var maxnews_id = userDefaults.objectForKey("newsCount") as! Int
                var maxnews_count = 0
                
                switch(maxnews_id as Int!) {
                    case 0: maxnews_count = 5
                    case 1: maxnews_count = 10
                    case 2: maxnews_count = 15
                    default: maxnews_count = 0 // ? s.o. 5
                }
                
                if (DEBUG) { print("MAXNEWS ID \(maxnews_id)") }
                if (DEBUG) { print("MAXNEWS COUNT \(maxnews_count)") }
                
                if(userAlreadyExist("newsCache")) {
                news_rss_items = userDefaults.objectForKey("newsCache")!.count
                } else {
                    news_rss_items = 0
                    if (DEBUG) { print("rss items = 0") }
                }
            
                    if(news_rss_items < maxnews_count) {
                        if (DEBUG) { print("temp temp temp") }
                        maxnews_count = news_rss_items
                    }
                
                    if(news_rss_items != 0) {
                        if (DEBUG) { print("loading cache ...") }
                        loadCache(maxnews_count)
                    } else {
                        if (DEBUG) { print("no cache , no data , no network") }
                        
                        // kein Primaerabzug erfolgt
                        if (DEBUG) { print("kein primaerabzug II (copy)") }
                        
                        
                        let alertController = UIAlertController(title: "Fehler", message: "Keine Verbindung zum Netzwerk vorhanden. Der Cache wurde noch nicht angelegt, da noch kein Primärabzug erfolgt ist. Die Darstellung der Auslastungsanzeige nicht möglich. Bitte stellen Sie eine Verbindung zum Internet her und probieren Sie es erneut.", preferredStyle: .Alert)
                        
                        let cancelAction = UIAlertAction(title: "Zurück", style: .Cancel) { (action) in
                            // MainView set as storyboard ID of MainViewController
                            // let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainView") as! MainViewController
                            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenu") as! MainMenuController
                            self.navigationController?.pushViewController(homeViewController, animated: true)
                            
                            // prufen ob das hier gebraucht wird, koop verhindern
                            // später auslagern, für den test reicht es
                            var firstRunReference: Int? = self.userDefaults.objectForKey("firstRun") as! Int?
                            if (firstRunReference == nil) {
                                firstRunReference = 1
                            } else {
                                // firstRunReference = self.userDefaults.objectForKey("firstRun") as! Int?
                                firstRunReference = 0
                                self.userDefaults.setObject(firstRunReference, forKey: "firstRun")
                            }
                        }
                        
                        let okAction = UIAlertAction(title: "Neu laden", style: .Default) { (action) in
                            self.viewDidLoad()
                        }
                        
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        //breakpoint
                        
                    }
                    

            } else {
                
                
                // showNetworkError
                
                if (DEBUG) { print("alert") }
                
                let alertController = UIAlertController(title: "Fehler", message: "Keine Verbindung zum Netzwerk vorhanden, kein Cache aktiviert. Darstellung der News nicht möglich. Bitte stellen Sie eine Verbindung zum Internet her und probieren Sie es erneut.", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Zurück", style: .Cancel) { (action) in
                    let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenu") as! MainMenuController
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    
                    // if at the moment of pressing back network is alive, activate redirection
                    if IJReachability.isConnectedToNetwork() {
                        self.userDefaults.setObject(1, forKey: "firstRun")
                    } else {
                        self.userDefaults.setObject(0, forKey: "firstRun")
                        // self.userDefaults.setObject(1, forKey: "backFromWebview")
                    }
                    self.userDefaults.synchronize()
                    
                    //// // prufen ob das hier gebraucht wird, koop verhindern
                    //// // später auslagern, für den test reicht es
                    ////var firstRunReference: Int? = self.userDefaults.objectForKey("firstRun") as! Int?
                    ////if (firstRunReference == nil) {
                    ////    firstRunReference = 1
                    ////} else {
                    ////    // firstRunReference = self.userDefaults.objectForKey("firstRun") as! Int?
                    ////    firstRunReference = 0
                    ////    self.userDefaults.setObject(firstRunReference, forKey: "firstRun")
                    //// }

                    
                }
                
                let okAction = UIAlertAction(title: "Neu laden", style: .Default) { (action) in
                    self.viewDidLoad()
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                
                if (DEBUG) { print("after alert") }
            }
            
                if (DEBUG) { print ("out of sight") }
        }
        
        /*
        // url = NSURL(string: "http://blog.bib.uni-mannheim.de/Aktuelles_Ex/?feed=rss2&cat=4")!
        // Call custom function.
        loadRss(url);
        */
    }
    
    func loadRss(data: NSURL) -> AnyObject {
        
        if (DEBUG) { print("loadRSS::start") }
        
        // XmlParserManager instance/object/variable
        var myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager
        // Put feed in array
        myFeed = myParser.feeds
        
        // if (DEBUG) { print(myFeed) }
        
        /*
        (
        {
        "content:encoded" = "";
        description = "";
        link = "";
        pubDate = "";
        title = "";
        },
        )
        */
        
        tableView.reloadData()
        
        if (DEBUG) { print("myFeed.count \(myFeed.count)") }
        
        return myFeed
    }
    
    func loadCache(newsCount: Int) {
        
        if (DEBUG) { print("loadCache::start") }
        
    // if (cache not empty)
    // else kann cache aufgrund fehlender Netzkonnektivität Cache nicht aufbauen
    // besser: in ConfigController
        
        // add parameter max_anz
        // already only execeuted when network is disconnected
        
        /*
        var cacheFeed = ["title": "", "description": "", "content:encoded": "", "link": "", "pubDate": ""]
        
        for news_item in self.news_cache {
            cacheFeed["title"] = news_item[0]
            cacheFeed["description"] = news_item[1]
            cacheFeed["content:encoded"] = news_item[2]
            cacheFeed["pubDate"] = news_item[3]
            cacheFeed["link"] = news_item[4]
        }
        */
        
        var news_count = newsCount

        if (DEBUG) { print("news_count uebergabe wert: \(news_count)") }
        /*
        var news_count = 5
        
        switch(newsCount as Int!) {
            case 0: news_count = 5
            case 1: news_count = 10
            case 2: news_count = 15
            default: news_count = 5
            }
        */
        // if (DEBUG) { print(news_count) }
        
        // if empty: no cache no network, reload?
        let newsentries: AnyObject = userDefaults.objectForKey("newsCache")!
        if (DEBUG) { print("Get Entry Nr.: 0 \(newsentries[0])") }
        if (DEBUG) { print("Get Entry Nr.: 0 and Title \(newsentries[0][0])") }
        
        // var dict : NSDictionary! = []
        // var cacheFeed : NSArray = []
        
        /*
        for (var i = 0; i < self.news_cache.count; i++) {
            cacheFeed[i] = "'content:encoded' = '"+(self.news_cache[i][2])+"';" +
                            "\ntitle = '"+(self.news_cache[i][1])+"';" +
                            "\npubDate = '"+(self.news_cache[i][3])+"';" +
                            "\nlink = '"+(self.news_cache[i][4])+"';" +
                            "\ntitle = '"+(self.news_cache[i][1])+"';"
        }
        */
        
        /*
        for (var i = 0; i < self.news_cache.count; i++) {
            cacheFeed += "'content:encoded' = \(newsentries[i][2]);"
            cacheFeed += "\ntitle = \(newsentries[i][1]);"
            cacheFeed += "\npubDate = \(newsentries[i][3]);"
            cacheFeed += "\nlink = \(newsentries[i][4]);"
        }
        */
        
        var myNewDictArray: [[String:AnyObject]] = []
        
        if (DEBUG) { print("newsentries.count \(newsentries.count)") }
        
        // wenn konfiguration offline geändert und noch keine reload des cache erfolgt ist
        if(newsentries.count < news_count) {
            news_count = newsentries.count
        }
        
        for (var i = 0; i < news_count; i++) {
            
        var tmp = ["title":newsentries[i][0], "content:encoded":newsentries[i][2], "pubDate":newsentries[i][3], "link":newsentries[i][4]]
        
        // if (DEBUG) { print(tmp) }
        
        myNewDictArray.append(tmp)
        }
        
        myFeed = myNewDictArray
        
        // if (DEBUG) { print(myNewDictArray) }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let newUrl = segue.destinationViewController as? NewFeedViewController {
            newUrl.onDataAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    weakSelf.loadRss(data)
                }
            }
        }
        
        else if segue.identifier == "openPage" {
            
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            // let selectedFeedURL: String = feeds[indexPath.row].objectForKey("link") as String
            let selectedFTitle: String = myFeed[indexPath.row].objectForKey("title") as! String
            // let selectedFContent: String = myFeed[indexPath.row].objectForKey("description") as String
            let selectedFContent: String = myFeed[indexPath.row].objectForKey("content:encoded") as! String
            let selectedFURL: String = myFeed[indexPath.row].objectForKey("link") as! String
            
            // Instance of our feedpageviewcontrolelr
            let fpvc: FeedPageViewController = segue.destinationViewController as! FeedPageViewController

            fpvc.selectedFeedTitle = selectedFTitle
            fpvc.selectedFeedFeedContent = selectedFContent
            // if (DEBUG) { print(selectedFContent) }
            fpvc.selectedFeedURL = selectedFURL
            
        }
    }

    /*
    func imageFromRSSContent(content: String) -> Void {
        
        var image: String = String()
        var content: String = content
        
        if let match = content.rangeOfString("<a\\s(?=.*?)[^>]*>$", options: .RegularExpressionSearch) {
            if (DEBUG) { print("\(content) with image") }
        }

    }
    */

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (DEBUG) { print("tableView::return_feed_count") }
        
        // return myFeed.count
        
        var feed_count = myFeed.count
        
        if (userDefaults.objectForKey("newsCount") != nil) {
            
            var maxnews_id = userDefaults.objectForKey("newsCount") as! Int
            var maxnews_count = 0
            
            switch(maxnews_id as Int!) {
            case 0: maxnews_count = 5
            case 1: maxnews_count = 10
            case 2: maxnews_count = 15
            default: maxnews_count = 5 // war 0
            }
            
            feed_count = maxnews_count
            
            if(myFeed.count < feed_count) {
                feed_count = myFeed.count
            }
        }
        
        if (DEBUG) { print("feeed count: \(feed_count)") }
        
        return feed_count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (DEBUG) { print("tableView::return_cell") }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        // Feed Image
        // cell.imageView?.image = UIImage (named: "news_pre")
        
        if(myFeed.count > 0) {
            // Feeds dictionary.
            var dict : NSDictionary! = myFeed.objectAtIndex(indexPath.row) as! NSDictionary
        
            // Set cell properties.
            cell.textLabel?.text = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String
        
            // It seems that cell.textLabel?.text is no longer an optionional.
            // If the above line throws an error then comment it out and uncomment the below line.
            //cell.textLabel?.text = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String

            var formattedFeedTitle = myFeed.objectAtIndex(indexPath.row).objectForKey("pubDate") as? String
        
            var date: String = formattedFeedTitle!
            let stringLength = date.characters.count
            let substringIndex = stringLength - 12
            // date = date.substringToIndex(advance(date.startIndex, substringIndex))
            date = date.substringToIndex(date.startIndex.advancedBy(substringIndex))
            
            if (DEBUG) { print("PUBATE WAS: \(date)") }
        
            // Englische in Deutsche Tage umformatieren
            date = date.stringByReplacingOccurrencesOfString("Mon", withString: "Mo")
            date = date.stringByReplacingOccurrencesOfString("Tue", withString: "Di")
            date = date.stringByReplacingOccurrencesOfString("Wed", withString: "Mi")
            date = date.stringByReplacingOccurrencesOfString("Thu", withString: "Do")
            date = date.stringByReplacingOccurrencesOfString("Fri", withString: "Fr")
            date = date.stringByReplacingOccurrencesOfString("Sat", withString: "Sa")
            date = date.stringByReplacingOccurrencesOfString("Sun", withString: "So")
        
            // "." hinter Tag hinzufügen
            date = replace(date, index: 6, newCharac: ".")
        
            if (DEBUG) { print("PUBATE IS: \(date)") }
        
        
            cell.detailTextLabel?.text = date
            // cell.detailTextLabel?.text = newDate
        
            var content = myFeed.objectAtIndex(indexPath.row).objectForKey("content:encoded") as? String
            // if (DEBUG) { print("FeedTableView: "+content!) }
        } else {
        
            // Set dummy cell properties (emtpy lines, no display of "title", "subtitle" ...)
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
        
        }
        
        return cell
    }
    /*
    extension String
    {
        func replace(target: String, withString: String) -> String
        {
            return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
    }
    */
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (DEBUG) { print("tableView::return_header_cell") }
        
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        // hide Title/Subtitle View in HeaderCell
        headerCell.textLabel?.hidden = true
        headerCell.detailTextLabel?.hidden = true
        
        // Create new Label ont the fly and add it to HeaderCell
        var label = UILabel(frame: CGRectMake(0, 0, 200, 55))
        label.textAlignment = NSTextAlignment.Center
        label.text = "Aktuelles aus der UB"
        headerCell.addSubview(label)
        
        headerCell.backgroundColor = uicolorFromHex(0xf7f7f7)
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    
    func replace(myString:String, index:Int, newCharac:Character) -> String {
        
        var modifiedString = myString
        let range = Range<String.Index>(
            // start: advance(myString.startIndex, index),
            // end: advance(myString.startIndex, index + 1))
            start: myString.startIndex.advancedBy(index),
            end: myString.startIndex.advancedBy(index+1))
        modifiedString.replaceRange(range, with: "\(newCharac)")
        return modifiedString
    }
    
    // auch in freeseats vorhanden
    func userAlreadyExist(kUSERID: String) -> Bool {
        var userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey(kUSERID) != nil) {
            return true
        }
        
        return false
    }
}
