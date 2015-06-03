//
//  SeatsTableViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 17.02.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit
import Foundation

// https://medium.com/swift-programming/http-in-swift-693b3a7bf086

class SeatsTableViewController: UITableViewController {

    var items: NSArray = NSArray()
    var data: NSMutableData = NSMutableData()
    
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    // UIRefreshControl
    func refresh(sender:AnyObject)
    {
        if IJReachability.isConnectedToNetwork() {
            
        // Updating your data here...
        loadJSONFromURL()
            
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
        super.viewDidLoad()
        
        
        let kfirstrun: Int? = userDefaults.objectForKey("firstRun") as! Int?
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        
        println("DEBUG MSG SeatsTabController : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup) [@Action: saveConfig]")
        
        
        // if pulled down, refresh
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        
        // if Network Connection online
        if IJReachability.isConnectedToNetwork() {
            
            println("connected")
            
            // searchItunesFor("JQ Software")
            loadJSONFromURL()
            
            // Cell height.
            self.tableView.rowHeight = 70
            self.tableView.dataSource = self
            self.tableView.delegate = self
            
            
            // "cell" might be added as identifier in designer and deleted here - right?
            self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            
            // self.tableView.reloadData()
        
        } else {
            
            // if() cache active
            
            if(userDefaults.objectForKey("cacheEnabled")?.boolValue == true) {
            
                if(userDefaults.objectForKey("wlanCache")!.count != 0) {
                    let wlan_entries: AnyObject = userDefaults.objectForKey("wlanCache")!
                    println("freshly filled preference: \(wlan_entries)")
                    
                    // loadJSONFromCache
                    
                } else {
                    
                    // kein Primaerabzug erfolgt
                }
                
            } else {
            
            // showNetworkError
            
            let alertController = UIAlertController(title: "Fehler", message: "Keine Verbindung zum Netzwerk vorhanden, kein Cache aktiviert. Darstellung der Auslastungsanzeige nicht möglich. Bitte stellen Sie eine Verbindung zum Internet her und probieren Sie es erneut.", preferredStyle: .Alert)
            
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
        
            }
        
        }
        
        
        // get rid of empty lines
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        var rowData: NSDictionary = self.items[indexPath.row] as! NSDictionary
        
        // cell.textLabel?.text = rowData["trackName"] as String!
        cell.textLabel?.text = rowData["id"] as! String!
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        // var urlString: NSString = rowData["artworkUrl60"] as NSString
        // var imgURL: NSURL = NSURL(string: urlString)!
        
        // Download an NSData representation of the image at the URL
        // var imgData: NSData = NSData(contentsOfURL: imgURL)!
        // cell.imageView?.image = UIImage(data: imgData)
        
        // Get the formatted price string for display in the subtitle
        // var formattedPrice: NSString = rowData["formattedPrice"] as NSString
        var loadInPercent: Int = rowData["percent"] as! Int
        var maxCountOfSeats: Int = rowData["max"] as! Int
        
        
        if(loadInPercent >= 81) {
                cell.imageView?.image = UIImage(named: "sign_red.png")
        }
        if(loadInPercent < 81) {
            cell.imageView?.image = UIImage(named: "sign_yellow.png")
        }
        if(loadInPercent < 61) {
            cell.imageView?.image = UIImage(named: "sign_green.png")
        }
        
        cell.detailTextLabel?.text = loadInPercent.description + "% (von " + maxCountOfSeats.description + " Arbeitsplätzen sind belegt)"
        
        return cell
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! UITableViewCell
        
        var lastUpdate : String = ""
        if(userDefaults.objectForKey("dateWLAN") != nil) {
            lastUpdate = userDefaults.objectForKey("dateWLAN") as! String
        }
        
        headerCell.textLabel?.text = "Zuletzt aktualisiert: " + lastUpdate
        headerCell.backgroundColor = uicolorFromHex(0xf7f7f7)
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }

    func loadJSONFromURL() {
        
        var urlPath = "http://www.bib.uni-mannheim.de/bereichsauslastung/index.php?json"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        
    // println("Search UB JSON Bereichsauslastung at URL \(url)")
        
        connection.start()
        
        /*
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.stringFromDate(date)
        */
        
        let date = getTimeStamp()
        println("Date: \(date)")
        
        userDefaults.setObject(date, forKey: "dateWLAN")
        userDefaults.synchronize()
    }
    
    func getTimeStamp() -> String {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        let timestring : String = timestamp as String!
        
        return timestring
    }
    
    /*
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlPath = "https://itunes.apple.com/search?term="+escapedSearchTerm!+"&media=software"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        
        println("Search iTunes API at URL \(url)")
        
        connection.start()
    }
    */
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Recieved a new request, clear out the data object
        self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        // Append the recieved chunk of data to our data object
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        // Request complete, self.data should now hold the resulting info
        // Convert the retrieved data in to an object through JSON deserialization
        var err: NSError
        
        if (userDefaults.objectForKey("cacheEnabled")?.boolValue == true) {
            
        // wenn cache enabled -> anzeigen und speichern
            
        // if (IJReachability.isConnectedToNetwork() && (userDefaults.objectForKey("cacheEnabled")?.boolValue == true)) {
                
            // save online wlan data in cache
            
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        
            var wlan_load = jsonResult
            
            userDefaults.setObject(wlan_load, forKey: "wlanCache")
            userDefaults.synchronize()
            
            if (jsonResult.count>0) /*&& jsonResult["results"].count>0*/ {
                var results: NSArray = jsonResult["sections"] as! NSArray
                self.items = results
                self.tableView.reloadData()
                
                // println(self.items)
            }
        
        } else {
            
            // wenn nicht nur aufrufen
            
            if (IJReachability.isConnectedToNetwork()) { // aus dem web
            
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
                if (jsonResult.count>0) /*&& jsonResult["results"].count>0*/ {
                    var results: NSArray = jsonResult["sections"] as! NSArray
                    self.items = results
                    self.tableView.reloadData()     // println(self.items)
                }

            } else {    // aus dem cache
        
            if (userDefaults.objectForKey("wlanCache")?.count > 0) {
                
                print("WLANNNNNNNNNNNNNNNNNNNNN")
            
                var cachedData : NSData = userDefaults.objectForKey("wlanCache") as! NSData
            
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(cachedData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
                if (jsonResult.count>0) /*&& jsonResult["results"].count>0*/ {
                    var results: NSArray = jsonResult["sections"] as! NSArray
                    self.items = results
                    self.tableView.reloadData()     // println(self.items)
                    }
                
                } else {
                    println("Kein Primaerabzug, keine Datene, kein Cache")
                }

        
                /* var wlan_load = self.items // userDefaults.setObject(wlan_load, forKey: "wlanCache") // userDefaults.synchronize() */
            }
    
        }
    }

}
