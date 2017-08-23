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
    
    let userDefaults:UserDefaults=UserDefaults.standard
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    // UIRefreshControl
    func refresh(_ sender:AnyObject)
    {
        if IJReachability.isConnectedToNetwork() {
            
        // Updating your data here...
        loadJSONFromURL()
            
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    
        } else {
            
            let dict = appDelegate.dict
            
            let alertMsg_Error: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "errorTitle")! as! String
            let alertMsg_Err_noNetwork: String = (dict.object(forKey: "FreeSeats")! as AnyObject).object(forKey: "noNetwork")! as! String
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
        super.viewDidLoad()
        
        
        let kfirstrun: Int? = userDefaults.object(forKey: "firstRun") as! Int?
        let kcache: Bool? = userDefaults.object(forKey: "cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.object(forKey: "newsCount") as! Int?
        let kstartup: Int? = userDefaults.object(forKey: "startupWith") as! Int?
        
        if (DEBUG) { print("DEBUG MSG SeatsTabController : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup) [@Action: saveConfig]") }
        
        
        // If pulled down, refresh
        self.refreshControl?.addTarget(self, action: #selector(SeatsTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        
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
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            self.tableView.reloadData()
        
        } else {
            
            // If Cache is active
            if((userDefaults.object(forKey: "cacheEnabled") as AnyObject).boolValue == true) {
            
                if(userAlreadyExist("wlanCache")) {
                if((userDefaults.object(forKey: "wlanCache")! as AnyObject).count != 0) {
                    
                    let wlan_data: AnyObject = userDefaults.object(forKey: "wlanCache")! as AnyObject
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
                    
                    let alertMsg_Error: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "errorTitle")! as! String
                    let alertMsg_Err_initCache: String = (dict.object(forKey: "FreeSeats")! as AnyObject).object(forKey: "initCache")! as! String
                    let alertMsg_back: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "cancelAction")! as! String
                    let alertMsg_reload: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "reloadAction")! as! String
                    
                    
                    // No Network Connection, data has not been pulled initially
                    
                    let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_initCache, preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: alertMsg_back, style: .cancel) { (action) in
                        
                        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenuController
                        self.navigationController?.pushViewController(homeViewController, animated: true)
                        
                        // FixMe
                        // Check if still used
                        // If possible source out
                        var firstRunReference: Int? = self.userDefaults.object(forKey: "firstRun") as! Int?
                        if (firstRunReference == nil) {
                            firstRunReference = 1
                        } else {
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
                }
                    
                } else { // Cache set, but wlan not filled yet
                
                    // If data has not been pulled initially yet
                    if (DEBUG) { print("kein primaerabzug II") }
                    
                    let dict = appDelegate.dict
                    
                    let alertMsg_Error: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "errorTitle")! as! String
                    let alertMsg_Err_createCache: String = (dict.object(forKey: "FreeSeats")! as AnyObject).object(forKey: "createCache")! as! String
                    let alertMsg_back: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "cancelAction")! as! String
                    let alertMsg_reload: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "reloadAction")! as! String
                    
                    let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_createCache, preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: alertMsg_back, style: .cancel) { (action) in
                        
                        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenuController
                        self.navigationController?.pushViewController(homeViewController, animated: true)
                        
                        // FixMe
                        // Check if still used
                        // If possible source out
                        var firstRunReference: Int? = self.userDefaults.object(forKey: "firstRun") as! Int?
                        if (firstRunReference == nil) {
                            firstRunReference = 1
                        } else {
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
                
                }
                
            } else {
            
            // show Network Error
                
                let dict = appDelegate.dict
                
                let alertMsg_Error: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "errorTitle")! as! String
                let alertMsg_Err_noCache_noNetwork: String = (dict.object(forKey: "FreeSeats")! as AnyObject).object(forKey: "noCache_noNetwork")! as! String
                let alertMsg_back: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "cancelAction")! as! String
                let alertMsg_reload: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "reloadAction")! as! String
            
                
                let alertController = UIAlertController(title: alertMsg_Error, message: alertMsg_Err_noCache_noNetwork, preferredStyle: .alert)
            
                let cancelAction = UIAlertAction(title: alertMsg_back, style: .cancel) { (action) in
                let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenuController
                self.navigationController?.pushViewController(homeViewController, animated: true)
                
                    // FixMe
                    // Check if still used
                    // If possible source out
                    var firstRunReference: Int? = self.userDefaults.object(forKey: "firstRun") as! Int?
                    if (firstRunReference == nil) {
                        firstRunReference = 1
                    } else {
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
        
            }
        
        }
        
        
        // Get rid of empty Table rows
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
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
        
        let label_seatsOccupied: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "FreeSeats")! as AnyObject).object(forKey: "seatsOccupied") as! String
        let label_ofPercentage: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "FreeSeats")! as AnyObject).object(forKey: "ofPercentage") as! String
        
        let detailTextLabelText = loadInPercent.description + label_ofPercentage + maxCountOfSeats.description + label_seatsOccupied // reserved?
        
        cell.detailTextLabel?.text = detailTextLabelText
        
        return cell
    }
    
    func uicolorFromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell")! as UITableViewCell
        
        var lastUpdate : String = ""
        if(userDefaults.object(forKey: "dateWLAN") != nil) {
            lastUpdate = userDefaults.object(forKey: "dateWLAN") as! String
        }
        
        let dict = appDelegate.dict
        
        let label_lastUpdated: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "FreeSeats")! as AnyObject).object(forKey: "lastUpdated") as! String
        let headerCellText = label_lastUpdated
        
        headerCell.textLabel?.text = headerCellText + lastUpdate
        headerCell.backgroundColor = uicolorFromHex(0xf7f7f7)
        
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }

    func loadJSONFromURL() {
        
        let dict = appDelegate.dict
        let url_FreeSeats: String = (dict.object(forKey: "urls")! as AnyObject).object(forKey: "FreeSeats") as! String
        
        let urlPath = url_FreeSeats
        let url: URL = URL(string: urlPath)!
        let request: URLRequest = URLRequest(url: url)
        let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        
        // print("Search UB JSON Bereichsauslastung at URL \(url)")
        
        connection.start()
        
        let date = getTimeStamp()
        if (DEBUG) { print("Date: \(date)") }
        
        userDefaults.set(date, forKey: "dateWLAN")
        userDefaults.synchronize()
    }
    
    func loadJSONFromCache() {
    
    }
    
    
    func getTimeStamp() -> String {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        
        let timestring : String = timestamp as String!
        
        return timestring
    }
    
    func connection(_ didReceiveResponse: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        // Recieved a new request, clear out the data object
        self.data = NSMutableData()
    }
    
    func connection(_ connection: NSURLConnection!, didReceiveData data: Data!) {
        // Append the recieved chunk of data to our data object
        self.data.append(data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection!) {
        // Request complete, self.data should now hold the resulting info
        // Convert the retrieved data in to an object through JSON deserialization
        let err: NSError

        do {
        let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
                if (jsonResult.count>0) /*&& jsonResult["results"].count>0*/ {
                    let results: NSArray = jsonResult["sections"] as! NSArray
                    self.items = results
                    self.tableView.reloadData()     // print(self.items)
                }
        } catch {
            print(err)
        }
        
            let wlan_load = self.items
            userDefaults.set(wlan_load, forKey: "wlanCache")
            userDefaults.synchronize() 
        
    }
    
    func userAlreadyExist(_ kUSERID: String) -> Bool {
        let userDefaults : UserDefaults = UserDefaults.standard
        
        if (userDefaults.object(forKey: kUSERID) != nil) {
            return true
        }
        
        return false
    }

}
