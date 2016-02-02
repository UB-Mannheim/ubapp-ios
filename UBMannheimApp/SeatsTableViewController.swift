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

    var DEBUG: Bool = false
    // if (DEBUG) {
    
    var items: NSArray = NSArray()
    var data: NSMutableData = NSMutableData()
    
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    // UIRefreshControl
    func refresh(sender:AnyObject)
    {
        if IJReachability.isConnectedToNetwork() {
            
        // Updating your data here...
        loadJSONFromURL()
            
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    
        } else {
            
            let dict = appDelegate.dict
            
            let alertMsg_Error: String = dict.objectForKey("alertMessages")!.objectForKey("errorTitle")! as! String
            //var alert_msg_error = "Error"
            let alertMsg_Err_noNetwork: String = dict.objectForKey("FreeSeats")!.objectForKey("noNetwork")! as! String
            // var alert_msg_network = "Network connection not available. Updating data is not possible. Please try again later."
            let alertMsg_OK: String = dict.objectForKey("alertMessages")!.objectForKey("okAction")! as! String
            // var alert_msg_ok = "OK"
            
            // if (preferredLanguage == "de") {
            //    alert_msg_error = "Fehler"
            //    alert_msg_network = "Keine Verbindung zum Netzwerk vorhanden. Aktualisierung der Daten nicht möglich. Bitte probieren Sie es später noch einmal."
            //    alert_msg_ok = "OK"
            // }
            
            let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_noNetwork, preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: alertMsg_OK, style: .Default) { (action) in
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
        
        if (DEBUG) { print("DEBUG MSG SeatsTabController : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup) [@Action: saveConfig]") }
        
        
        // if pulled down, refresh
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        // if Network Connection online
        if IJReachability.isConnectedToNetwork() {
            
            if (DEBUG) { print("connected") }
            
            // searchItunesFor("JQ Software")
            loadJSONFromURL()
            
            // "cell" might be added as identifier in designer and deleted here - right?
            self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            self.tableView.reloadData()
        
        } else {
            
            // if() cache active
            
            if(userDefaults.objectForKey("cacheEnabled")?.boolValue == true) {
            
                if(userAlreadyExist("wlanCache")) {
                if(userDefaults.objectForKey("wlanCache")!.count != 0) {
                    
                    let wlan_data: AnyObject = userDefaults.objectForKey("wlanCache")!
                    if (DEBUG) { print("freshly filled preference: \(wlan_data)") }
                    
                    // load From Cache
    
                    // var wlan_item = [["", "", "", ""], ["", "", "", ""], ["", "", "", ""], ["", "", "", ""], ["", "", "", ""], ["", "", "", ""]]
                    // if (DEBUG) { print("------------ before for ---------------") }
                    // if (DEBUG) { print(wlan_data) }
                    
                    self.items = wlan_data as! NSArray
                    self.tableView.reloadData()
                    
                    // if (DEBUG) { print("------------ items after ---------------") }
                    // if (DEBUG) { print(self.items) }
                    
                    
                    // http://stackoverflow.com/questions/26840736/converting-json-to-nsdata-and-nsdata-to-json-in-swift
                    
                    
                    /*
                    for (var i = 0; i < wlan_item.; i++) {
                        
                        if (DEBUG) { print("for \(i)") }
                        
                        var id = wlan_data["sections"][i]["id"] as! String
                        var max = wlan_data[1][i].objectForKey("max") as! String
                        var name = wlan_data[1][i].objectForKey("name") as! String
                        var percent = wlan_data[1][i].objectForKey("percent") as! String
                        
                        wlan_item[i] = [id, max, name, percent]
                        if (DEBUG) { print(wlan_item[i]) }
                        
                        // self.data.appendData(wlan_item)
                    }
                    */
                    
                } else {
                    
                    // kein Primaerabzug erfolgt
                    if (DEBUG) { print("kein primaerabzug") }
                    
                    let dict = appDelegate.dict
                    
                    let alertMsg_Error: String = dict.objectForKey("alertMessages")!.objectForKey("errorTitle")! as! String
                    let alertMsg_Err_initCache: String = dict.objectForKey("FreeSeats")!.objectForKey("initCache")! as! String
                    let alertMsg_back: String = dict.objectForKey("alertMessages")!.objectForKey("cancelAction")! as! String
                    let alertMsg_reload: String = dict.objectForKey("alertMessages")!.objectForKey("reloadAction")! as! String
                    
                    // var alert_msg_error = "Error"
                    // var alert_msg_network = "Network connection not available. Cache could not be initialized. Displaying Free Seats is not possible. Please connect your device to the internet at least one time and then try again."
                    // var alert_msg_back = "Back"
                    // var alert_msg_reload = "Reload"
                    
                    // if (preferredLanguage == "de") {
                    //    alert_msg_error = "Fehler"
                    //    alert_msg_network = "Keine Verbindung zum Netzwerk vorhanden. Der Cache wurde noch nicht angelegt, da noch kein Primärabzug erfolgt ist. Die Darstellung der Auslastungsanzeige nicht möglich. Bitte stellen Sie eine Verbindung zum Internet her und probieren Sie es erneut."
                    //    alert_msg_back = "Zurück"
                    //    alert_msg_reload = "Neu laden"
                    // }
                    
                    
                    // Keine Verbindung zum Netzwerk vorhanden, kein Primärabzug erfolgt.
                    
                    let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_initCache, preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: alertMsg_back, style: .Cancel) { (action) in
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
                    
                    let okAction = UIAlertAction(title: alertMsg_reload, style: .Default) { (action) in
                        self.viewDidLoad()
                    }
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                    
                } else { // cache set, but wlan cache not filled
                
                    // kein Primaerabzug erfolgt
                    if (DEBUG) { print("kein primaerabzug II") }
                    
                    
                    let dict = appDelegate.dict
                    
                    let alertMsg_Error: String = dict.objectForKey("alertMessages")!.objectForKey("errorTitle")! as! String
                    let alertMsg_Err_createCache: String = dict.objectForKey("FreeSeats")!.objectForKey("createCache")! as! String
                    let alertMsg_back: String = dict.objectForKey("alertMessages")!.objectForKey("cancelAction")! as! String
                    let alertMsg_reload: String = dict.objectForKey("alertMessages")!.objectForKey("reloadAction")! as! String
                    
                    
                    // var alert_msg_error = "Error"
                    // var alert_msg_network = "Network connection not available, cache could not be initialized. Displaying Free Seats is not possible at the moment. Please connect your device to the internet at least one time and try again."
                    // var alert_msg_back = "Back"
                    // var alert_msg_reload = "Reload"
                    
                    // if (preferredLanguage == "de") {
                    //    alert_msg_error = "Fehler"
                    //    alert_msg_network = "Keine Verbindung zum Netzwerk vorhanden. Der Cache wurde noch nicht angelegt, da noch kein Primärabzug erfolgt ist. Die Darstellung der Auslastungsanzeige nicht möglich. Bitte stellen Sie eine Verbindung zum Internet her und probieren Sie es erneut."
                    //    alert_msg_back = "Zurück"
                    //    alert_msg_reload = "Neu laden"
                    // }
                    
                    let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_createCache, preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: alertMsg_back, style: .Cancel) { (action) in
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
                    
                    let okAction = UIAlertAction(title: alertMsg_reload, style: .Default) { (action) in
                        self.viewDidLoad()
                    }
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                
                }
                
            } else {
            
            // showNetworkError
                
                let dict = appDelegate.dict
                
                let alertMsg_Error: String = dict.objectForKey("alertMessages")!.objectForKey("errorTitle")! as! String
                let alertMsg_Err_noCache_noNetwork: String = dict.objectForKey("FreeSeats")!.objectForKey("noCache_noNetwork")! as! String
                let alertMsg_back: String = dict.objectForKey("alertMessages")!.objectForKey("cancelAction")! as! String
                let alertMsg_reload: String = dict.objectForKey("alertMessages")!.objectForKey("reloadAction")! as! String
            
                // var alert_msg_error = "Error"
                // var alert_msg_network = "Network connection not available, no cache activated. Displaying Free Seats is not possible at the moment. Please connect your device to the internet and try again."
                // var alert_msg_back = "Back"
                // var alert_msg_reload = "Reload"
                
                // if (preferredLanguage == "de") {
                //    alert_msg_error = "Fehler"
                //    alert_msg_network = "Keine Verbindung zum Netzwerk vorhanden, kein Cache aktiviert. Darstellung der Auslastungsanzeige nicht möglich. Bitte stellen Sie eine Verbindung zum Internet her und probieren Sie es erneut."
                //    alert_msg_back = "Zurück"
                //    alert_msg_reload = "Neu laden"
                // }

                
            let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_noCache_noNetwork, preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: alertMsg_back, style: .Cancel) { (action) in
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
            
            let okAction = UIAlertAction(title: alertMsg_reload, style: .Default) { (action) in
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
        
        let rowData: NSDictionary = self.items[indexPath.row] as! NSDictionary
        
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
        let loadInPercent: Int = rowData["percent"] as! Int
        let maxCountOfSeats: Int = rowData["max"] as! Int
        
        
        if(loadInPercent >= 81) {
                cell.imageView?.image = UIImage(named: "sign_red.png")
        }
        if(loadInPercent < 81) {
            cell.imageView?.image = UIImage(named: "sign_yellow.png")
        }
        if(loadInPercent < 61) {
            cell.imageView?.image = UIImage(named: "sign_green.png")
        }
        
        
        let dict = appDelegate.dict
        
        let label_seatsOccupied: String = dict.objectForKey("labels")!.objectForKey("FreeSeats")!.objectForKey("seatsOccupied") as! String
        let label_ofPercentage: String = dict.objectForKey("labels")!.objectForKey("FreeSeats")!.objectForKey("ofPercentage") as! String
        
        let detailTextLabelText = loadInPercent.description + label_ofPercentage + maxCountOfSeats.description + label_seatsOccupied // reserved?
        
        // var detailTextLabelText = loadInPercent.description + "% of " + maxCountOfSeats.description + " Seats are occupied" // reserved?
        
        // if (preferredLanguage == "de") {
        //     detailTextLabelText = loadInPercent.description + "% von " + maxCountOfSeats.description + " Arbeitsplätzen sind belegt"
        // }
        
        cell.detailTextLabel?.text = detailTextLabelText
        
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
        
        var lastUpdate : String = ""
        if(userDefaults.objectForKey("dateWLAN") != nil) {
            lastUpdate = userDefaults.objectForKey("dateWLAN") as! String
        }
        
        let dict = appDelegate.dict
        
        let label_lastUpdated: String = dict.objectForKey("labels")!.objectForKey("FreeSeats")!.objectForKey("lastUpdated") as! String
        let headerCellText = label_lastUpdated
        
        // var headerCellText = "Last updated on: "
        
        // if (preferredLanguage == "de") {
        //    headerCellText = "Zuletzt aktualisiert: "
        // }
        
        headerCell.textLabel?.text = headerCellText + lastUpdate
        headerCell.backgroundColor = uicolorFromHex(0xf7f7f7)
        
        return headerCell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }

    func loadJSONFromURL() {
        
        let dict = appDelegate.dict
        let url_FreeSeats: String = dict.objectForKey("urls")!.objectForKey("FreeSeats") as! String
        
        let urlPath = url_FreeSeats
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        
    // print("Search UB JSON Bereichsauslastung at URL \(url)")
        
        connection.start()
        
        /*
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.stringFromDate(date)
        */
        
        let date = getTimeStamp()
        if (DEBUG) { print("Date: \(date)") }
        
        userDefaults.setObject(date, forKey: "dateWLAN")
        userDefaults.synchronize()
    }
    
    func loadJSONFromCache() {
    
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
        
        print("Search iTunes API at URL \(url)")
        
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

        do {
        var jsonResult: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
                if (jsonResult.count>0) /*&& jsonResult["results"].count>0*/ {
                    var results: NSArray = jsonResult["sections"] as! NSArray
                    self.items = results
                    self.tableView.reloadData()     // print(self.items)
                }
        } catch {
            print(err)
        }
        
            var wlan_load = self.items
            userDefaults.setObject(wlan_load, forKey: "wlanCache")
            userDefaults.synchronize() 
        
    }
    
    func userAlreadyExist(kUSERID: String) -> Bool {
        var userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey(kUSERID) != nil) {
            return true
        }
        
        return false
    }

}
