//
//  SeatsTableViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 17.02.15.
//  Last modified on 22.03.16.
//
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//
//

import UIKit
import Foundation

class SeatsTableViewController: UITableViewController {

    var DEBUG: Bool = false
    // if (DEBUG) {}
    
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
            let alertMsg_Err_noNetwork: String = dict.objectForKey("FreeSeats")!.objectForKey("noNetwork")! as! String
            let alertMsg_OK: String = dict.objectForKey("alertMessages")!.objectForKey("okAction")! as! String
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
        
        
        // If pulled down, refresh
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Set Table Layout and Cell Height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        // If Network Connection online
        if IJReachability.isConnectedToNetwork() {
            
            if (DEBUG) { print("connected") }
            
            // getJSON from Endpoint
            loadJSONFromURL()
            
            // "cell" might be added as identifier in designer and deleted here - right?
            self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            self.tableView.reloadData()
        
        } else {
            
            // If Cache is active
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
                    
                    // If data has not been pulled initially yet
                    if (DEBUG) { print("kein primaerabzug") }
                    
                    let dict = appDelegate.dict
                    
                    let alertMsg_Error: String = dict.objectForKey("alertMessages")!.objectForKey("errorTitle")! as! String
                    let alertMsg_Err_initCache: String = dict.objectForKey("FreeSeats")!.objectForKey("initCache")! as! String
                    let alertMsg_back: String = dict.objectForKey("alertMessages")!.objectForKey("cancelAction")! as! String
                    let alertMsg_reload: String = dict.objectForKey("alertMessages")!.objectForKey("reloadAction")! as! String
                    
                    
                    // No Network Connection, data has not been pulled initially
                    
                    let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_initCache, preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: alertMsg_back, style: .Cancel) { (action) in
                        
                        let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenu") as! MainMenuController
                        self.navigationController?.pushViewController(homeViewController, animated: true)
                        
                        // FixMe
                        // Check if still used
                        // If possible source out
                        var firstRunReference: Int? = self.userDefaults.objectForKey("firstRun") as! Int?
                        if (firstRunReference == nil) {
                            firstRunReference = 1
                        } else {
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
                    
                } else { // Cache set, but wlan not filled yet
                
                    // If data has not been pulled initially yet
                    if (DEBUG) { print("kein primaerabzug II") }
                    
                    let dict = appDelegate.dict
                    
                    let alertMsg_Error: String = dict.objectForKey("alertMessages")!.objectForKey("errorTitle")! as! String
                    let alertMsg_Err_createCache: String = dict.objectForKey("FreeSeats")!.objectForKey("createCache")! as! String
                    let alertMsg_back: String = dict.objectForKey("alertMessages")!.objectForKey("cancelAction")! as! String
                    let alertMsg_reload: String = dict.objectForKey("alertMessages")!.objectForKey("reloadAction")! as! String
                    
                    let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_createCache, preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: alertMsg_back, style: .Cancel) { (action) in
                        
                        let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenu") as! MainMenuController
                        self.navigationController?.pushViewController(homeViewController, animated: true)
                        
                        // FixMe
                        // Check if still used
                        // If possible source out
                        var firstRunReference: Int? = self.userDefaults.objectForKey("firstRun") as! Int?
                        if (firstRunReference == nil) {
                            firstRunReference = 1
                        } else {
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
            
            // show Network Error
                
                let dict = appDelegate.dict
                
                let alertMsg_Error: String = dict.objectForKey("alertMessages")!.objectForKey("errorTitle")! as! String
                let alertMsg_Err_noCache_noNetwork: String = dict.objectForKey("FreeSeats")!.objectForKey("noCache_noNetwork")! as! String
                let alertMsg_back: String = dict.objectForKey("alertMessages")!.objectForKey("cancelAction")! as! String
                let alertMsg_reload: String = dict.objectForKey("alertMessages")!.objectForKey("reloadAction")! as! String
            
                
                let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_noCache_noNetwork, preferredStyle: .Alert)
            
                let cancelAction = UIAlertAction(title: alertMsg_back, style: .Cancel) { (action) in
                let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenu") as! MainMenuController
                self.navigationController?.pushViewController(homeViewController, animated: true)
                
                    // FixMe
                    // Check if still used
                    // If possible source out
                    var firstRunReference: Int? = self.userDefaults.objectForKey("firstRun") as! Int?
                    if (firstRunReference == nil) {
                        firstRunReference = 1
                    } else {
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
        
        
        // Get rid of empty Table rows
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        let rowData: NSDictionary = self.items[indexPath.row] as! NSDictionary
        cell.textLabel?.text = rowData["id"] as! String!
        
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
        let err: NSError

        do {
        let jsonResult: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
                if (jsonResult.count>0) /*&& jsonResult["results"].count>0*/ {
                    let results: NSArray = jsonResult["sections"] as! NSArray
                    self.items = results
                    self.tableView.reloadData()     // print(self.items)
                }
        } catch {
            print(err)
        }
        
            let wlan_load = self.items
            userDefaults.setObject(wlan_load, forKey: "wlanCache")
            userDefaults.synchronize() 
        
    }
    
    func userAlreadyExist(kUSERID: String) -> Bool {
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey(kUSERID) != nil) {
            return true
        }
        
        return false
    }

}
