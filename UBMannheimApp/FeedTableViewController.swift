//
//  FeedTableViewController.swift
//  RSSwift
//
//  Created by Arled Kola on 20/09/2014.
//  Copyright (c) 2014 Arled. All rights reserved.
//
//  Last modified by Universitätsbibliothek Mannheim on 22.03.2016
//
//

import UIKit

class FeedTableViewController: UITableViewController, XMLParserDelegate {

    var DEBUG: Bool = false
    
    var myFeed : NSArray = []
    var url: URL = URL(fileURLWithPath: "http://www.bib.uni-mannheim.de")
    
    let userDefaults:UserDefaults=UserDefaults.standard
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var news_feed : Int = 5
    var news_cache: [[String]] = []
    var news_rss_items = 0
    
    // UIRefreshControl
    func refresh(_ sender:AnyObject)
    {
        if (DEBUG) { print("refresh::start") }
        
        if IJReachability.isConnectedToNetwork() {
            
        // FixMe
        // Check Newscount when Network ist online
        // Don't show more News Items than available
        // i.e. 5 < 7
            
        // Updating your data here...
        loadRss(url)
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        
        } else {
            
            let dict = appDelegate.dict
            
            let alertMsg_Error: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "errorTitle")! as! String
            
            // let alertMsg_Err_noNetwork: String = (dict.object(forKey: "News")! as AnyObject).object(forKey: "noNetwork")! as! String
            let alertDict: NSDictionary = (dict.object(forKey: "alertMessages")! as AnyObject) as! NSDictionary
            let newsDict: NSDictionary = (alertDict.object(forKey: "News")! as AnyObject) as! NSDictionary
            let txt: String = newsDict.object(forKey: "noNetwork")! as! String
            let alertMsg_Err_noNetwork: String = txt
            
            let alertMsg_OK: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "okAction")! as! String
            
            let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_noNetwork, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: alertMsg_OK, style: .default) { (action) in
                self.viewDidLoad()
            }
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            self.refreshControl?.endRefreshing()
        }
        
    }

    override func viewDidLoad() {
        
        if (DEBUG) { print("didLoad::start") }
        
        super.viewDidLoad()
        
        let news_entries = userDefaults.object(forKey: "newsCount") as! Int?
        if (news_entries != nil) {
            switch(news_entries as Int!) {
            case 0: news_feed = 5
            case 1: news_feed = 10
            case 2: news_feed = 15
            default: news_feed = 15
            }
        }
        
        let kfirstrun: Int? = userDefaults.object(forKey: "firstRun") as! Int?
        let kcache: Bool? = userDefaults.object(forKey: "cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.object(forKey: "newsCount") as! Int?
        let kstartup: Int? = userDefaults.object(forKey: "startupWith") as! Int?
        
        if (DEBUG) { print("DEBUG MSG FeedTabVController : FirstRun = \(String(describing: kfirstrun)) | Cache = \(String(describing: kcache)) | News = \(String(describing: knews)) | Startup \(String(describing: kstartup)) [@Info: showing \(news_feed) Entries]") }
        
        // If Control pulled down, refresh
        self.refreshControl?.addTarget(self, action: #selector(FeedTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)

        // Set Table Layout and Cell Height
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Get rid of empty lines
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        
        // Set Feed URL
        url = URL(string: "http://blog.bib.uni-mannheim.de/Aktuelles/?feed=rss2&cat=4")!
        
        // If Network Connection online
        if IJReachability.isConnectedToNetwork() {
            
            if (DEBUG) { print("connected") }
            
            let news_rssdata: AnyObject = loadRss(url)
            news_rss_items = news_rssdata.count
            
            if (DEBUG) { print("news rss data count: \(news_rss_items)") }
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            
            //  If Cache on
            if((userDefaults.object(forKey: "cacheEnabled") as AnyObject).boolValue == true) {
              
            // If (DEBUG) { print("Cache on ....................................................") }
                //  Update Cache Entries
                var maxnews_count = userDefaults.object(forKey: "newsCount") as! Int
                
                // Attention maxnews_count >> picker_select(0,1,2) != count(5,10,15)
                
                switch(maxnews_count) {
                    case 0: maxnews_count = 5
                        break
                    case 1: maxnews_count = 10
                        break
                    case 2: maxnews_count = 15
                        break
                    default: maxnews_count = 5 // ? s.u. 0
                }
                
                // if (DEBUG) { print("didLoad::maxnews_count \(maxnews_count) ....................................................") }
                // if (DEBUG) { print("NEWS COUNT") }
                // if (DEBUG) { print(news_rssdata.count) }
                
                
                if(news_rssdata.count < maxnews_count) {
                    maxnews_count = news_rssdata.count
                }
                
                // if (DEBUG) { print("maxnews_count = \(maxnews_count)") }
                var news_item = ["", "", "", "", ""]
                
                for i in 0 ..< maxnews_count {
                    
                    // if (DEBUG) { print("row per row ....................................................") }
                    // if (DEBUG) { print("News mit ID=\(i) \(news_rssdata[i])") TMP s.o. voher ausgabe der news, aus debugzwecken ausgeklammert }
                    
                    /*
                    news_item[0] = (news_rssdata.object(forKey: i) as AnyObject).object(forKey: "title") as! String
                    news_item[1] = (news_rssdata.object(forKey: i) as AnyObject).object(forKey: "description") as! String
                    news_item[2] = (news_rssdata.object(forKey: i) as AnyObject).object(forKey: "content:encoded") as! String
                    news_item[3] = (news_rssdata.object(forKey: i) as AnyObject).object(forKey: "pubDate") as! String
                    news_item[4] = (news_rssdata.object(forKey: i) as AnyObject).object(forKey: "link") as! String
                    */
                    
                    news_item[0] = (news_rssdata.object(at: i) as AnyObject).object(forKey: "title") as! String
                    news_item[1] = (news_rssdata.object(at: i) as AnyObject).object(forKey: "description") as! String
                    news_item[2] = (news_rssdata.object(at: i) as AnyObject).object(forKey: "content:encoded") as! String
                    news_item[3] = (news_rssdata.object(at: i) as AnyObject).object(forKey: "pubDate") as! String
                    news_item[4] = (news_rssdata.object(at: i) as AnyObject).object(forKey: "link") as! String
                    
                    self.news_cache.append(news_item)
                }
                
                userDefaults.set(self.news_cache, forKey: "newsCache")
                userDefaults.synchronize()
                
                let newsentries: AnyObject = userDefaults.object(forKey: "newsCache")! as AnyObject
                if (DEBUG) { print("freshly filled preference: \(newsentries)") }
            }
            
            
        } else {
            
            if (DEBUG) { print("No Network available") }
            
            // if Cache on
            if ( ((userDefaults.object(forKey: "cacheEnabled") as AnyObject).boolValue == true) ) { // && (userDefaults.objectForKey("newsCache") != nil) ) {
            
            
                let maxnews_id = userDefaults.object(forKey: "newsCount") as! Int
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
                news_rss_items = (userDefaults.object(forKey: "newsCache")! as AnyObject).count
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
                        
                        let dict = appDelegate.dict
                        
                        let alertMsg_Error: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "errorTitle")! as! String
                        // let alertMsg_Err_initCache: String = (dict.object(forKey: "News")! as AnyObject).object(forKey: "initCache")! as! String
                        let alertDict: NSDictionary = (dict.object(forKey: "alertMessages")! as AnyObject) as! NSDictionary
                        let newsDict: NSDictionary = (alertDict.object(forKey: "News")! as AnyObject) as! NSDictionary
                        let txt: String = newsDict.object(forKey: "initCache")! as! String
                        let alertMsg_Err_initCache: String = txt
                        
                        let alertMsg_back: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "cancelAction")! as! String
                        let alertMsg_reload: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "reloadAction")! as! String
                        
                        let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_initCache, preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: alertMsg_back, style: .cancel) { (action) in
                            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenuController
                            self.navigationController?.pushViewController(homeViewController, animated: true)
                            
                            // prufen ob das hier gebraucht wird, koop verhindern
                            // später auslagern, für den test reicht es
                            var firstRunReference: Int? = self.userDefaults.object(forKey: "firstRun") as! Int?
                            if (firstRunReference == nil) {
                                firstRunReference = 1
                            } else {
                                // firstRunReference = self.userDefaults.objectForKey("firstRun") as! Int?
                                firstRunReference = 0
                                self.userDefaults.set(firstRunReference, forKey: "firstRun")
                            }
                        }
                        
                        let okAction = UIAlertAction(title: alertMsg_reload, style: .default) { (action) in
                            self.viewDidLoad()
                        }
                        
                        alertController.addAction(cancelAction)
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                        //breakpoint
                        
                    }
                    

            } else {
                
                
                // showNetworkError
                
                if (DEBUG) { print("alert") }
                
                let dict = appDelegate.dict
                
                if (DEBUG) { print("dict loaded") }
                
                
                let alertMsg_Error: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "errorTitle")! as! String
                if (DEBUG) { print("errorTitle loaded") }
                
                // let alertMsg_Err_noCache_noNetwork: String = (dict.object(forKey: "News")! as AnyObject).object(forKey: "noCache_noNetwork")! as! String
                // let alertMsg_Err_noCache_noNetwork: String = "noCache_noNetwork"
                
                let alertDict: NSDictionary = (dict.object(forKey: "alertMessages")! as AnyObject) as! NSDictionary
                let newsDict: NSDictionary = (alertDict.object(forKey: "News")! as AnyObject) as! NSDictionary
                let txt: String = newsDict.object(forKey: "noCache_noNetwork")! as! String
                let alertMsg_Err_noCache_noNetwork: String = txt
 

                if (DEBUG) { print("noCache_noNetwork loaded") }
                
                let alertMsg_back: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "cancelAction")! as! String
                let alertMsg_reload: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "reloadAction")! as! String
                if (DEBUG) { print("cancel and reload action loaded") }

                let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_noCache_noNetwork, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: alertMsg_back, style: .cancel) { (action) in
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenuController
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    
                    // if at the moment of pressing back network is alive, activate redirection
                    if IJReachability.isConnectedToNetwork() {
                        self.userDefaults.set(1, forKey: "firstRun")
                    } else {
                        self.userDefaults.set(0, forKey: "firstRun")
                        // self.userDefaults.setObject(1, forKey: "backFromWebview")
                    }
                    self.userDefaults.synchronize()
                    
                }
                
                let okAction = UIAlertAction(title: alertMsg_reload, style: .default) { (action) in
                    self.viewDidLoad()
                }
                
                if (DEBUG) { print("alert controller set") }
                
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                
                if (DEBUG) { print("alert controller will be presented: ...") }
                
                self.present(alertController, animated: true, completion: nil)
                
                
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
    
    func loadRss(_ data: URL) -> AnyObject {
        
        if (DEBUG) { print("loadRSS::start") }
        
        // XmlParserManager instance/object/variable
        let myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager
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
    
    func loadCache(_ newsCount: Int) {
        
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
        let newsentries: AnyObject = userDefaults.object(forKey: "newsCache")! as AnyObject
        // if (DEBUG) { print("Get Entry Nr.: 0 \(newsentries[0])") }
        // if (DEBUG) { print("Get Entry Nr.: 0 and Title \(newsentries[0][0])") }
        
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
        
        for i in 0 ..< news_count {
            
        // let tmp = ["title":newsentries[i][0], "content:encoded":newsentries[i][2], "pubDate":newsentries[i][3], "link":newsentries[i][4]]
        
        
            // let elements: [AnyObject] = (newsentries.object(forKey: i) as AnyObject) as! [AnyObject]
            let elements: [AnyObject] = (newsentries.object(at: i) as AnyObject) as! [AnyObject]
                let title = elements[0] as! String
                let content = elements[2] as! String
                let pubdate = elements[3] as! String
                let link = elements[4] as! String
            
 
        let tmp = ["title":title, "content:encoded":content, "pubDate":pubdate, "link":link]
            
            
        if (DEBUG) { print(tmp) }
        // myNewDictArray.append(tmp)
            
        myNewDictArray.append(tmp as [String : AnyObject])
        }
        
        myFeed = myNewDictArray as NSArray
        
        // if (DEBUG) { print(myNewDictArray) }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let newUrl = segue.destination as? NewFeedViewController {
            newUrl.onDataAvailable = {[weak self]
                (data) in
                if let weakSelf = self {
                    weakSelf.loadRss(data as URL)
                }
            }
        }
        
        else if segue.identifier == "openPage" {
            
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            // let selectedFeedURL: String = feeds[indexPath.row].objectForKey("link") as String
            let selectedFTitle: String = (myFeed[indexPath.row] as AnyObject).object(forKey: "title") as! String
            // let selectedFContent: String = myFeed[indexPath.row].objectForKey("description") as String
            let selectedFContent: String = (myFeed[indexPath.row] as AnyObject).object(forKey: "content:encoded") as! String
            let selectedFURL: String = (myFeed[indexPath.row] as AnyObject).object(forKey: "link") as! String
            
            // Instance of our feedpageviewcontrolelr
            let fpvc: FeedPageViewController = segue.destination as! FeedPageViewController

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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (DEBUG) { print("tableView::return_feed_count") }
        
        // return myFeed.count
        
        var feed_count = myFeed.count
        
        if (userDefaults.object(forKey: "newsCount") != nil) {
            
            let maxnews_id = userDefaults.object(forKey: "newsCount") as! Int
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (DEBUG) { print("tableView::return_cell") }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Feed Image
        // cell.imageView?.image = UIImage (named: "news_pre")
        
        if(myFeed.count > 0) {
            // Feeds dictionary.
            // var dict : NSDictionary! = myFeed.objectAtIndex(indexPath.row) as! NSDictionary
        
            // Set cell properties.
            cell.textLabel?.text = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "title") as? String
        
            // It seems that cell.textLabel?.text is no longer an optionional.
            // If the above line throws an error then comment it out and uncomment the below line.
            //cell.textLabel?.text = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String

            let formattedFeedTitle = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "pubDate") as? String
        
            var date: String = formattedFeedTitle!
            let stringLength = date.characters.count
            let substringIndex = stringLength - 12
            // date = date.substringToIndex(advance(date.startIndex, substringIndex))
            date = date.substring(to: date.characters.index(date.startIndex, offsetBy: substringIndex))
            
            if (DEBUG) { print("PUBATE WAS: \(date)") }
        
            // Englische in Deutsche Tage umformatieren
            date = date.replacingOccurrences(of: "Mon", with: "Mo")
            date = date.replacingOccurrences(of: "Tue", with: "Di")
            date = date.replacingOccurrences(of: "Wed", with: "Mi")
            date = date.replacingOccurrences(of: "Thu", with: "Do")
            date = date.replacingOccurrences(of: "Fri", with: "Fr")
            date = date.replacingOccurrences(of: "Sat", with: "Sa")
            date = date.replacingOccurrences(of: "Sun", with: "So")
        
            // "." hinter Tag hinzufügen
            date = replace(date, index: 6, newCharac: ".")
        
            if (DEBUG) { print("PUBATE IS: \(date)") }
        
        
            cell.detailTextLabel?.text = date
            // cell.detailTextLabel?.text = newDate
        
            // var content = myFeed.objectAtIndex(indexPath.row).objectForKey("content:encoded") as? String
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
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (DEBUG) { print("tableView::return_header_cell") }
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let dict = appDelegate.dict
        
        let label_newsHeader: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "News")! as AnyObject).object(forKey: "title") as! String
        let headerCellText = label_newsHeader
        
        /*
        var headerCellText = "Latest Library News"
        
        if (preferredLanguage == "de") {
            headerCellText = "Aktuelles aus der UB"
        }
        */
        
        // hide Title/Subtitle View in HeaderCell
        headerCell.textLabel?.isHidden = true
        headerCell.detailTextLabel?.isHidden = true
        
        // Create new Label ont the fly and add it to HeaderCell
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
        label.textAlignment = NSTextAlignment.center
        label.text = headerCellText
        headerCell.addSubview(label)
        
        headerCell.backgroundColor = uicolorFromHex(0xf7f7f7)
        
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
    
    func replace(_ myString:String, index:Int, newCharac:Character) -> String {
        
        var modifiedString = myString
        let range = (myString.characters.index(myString.startIndex, offsetBy: index) ..< myString.characters.index(myString.startIndex, offsetBy: index+1))
        modifiedString.replaceSubrange(range, with: "\(newCharac)")
        return modifiedString
    }
    
    // auch in freeseats vorhanden
    func userAlreadyExist(_ kUSERID: String) -> Bool {
        let userDefaults : UserDefaults = UserDefaults.standard
        
        if (userDefaults.object(forKey: kUSERID) != nil) {
            return true
        }
        
        return false
    }
}
