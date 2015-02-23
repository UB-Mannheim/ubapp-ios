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
    
    // UIRefreshControl
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        loadJSONFromURL()
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if pulled down, refresh
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        // searchItunesFor("JQ Software")
        loadJSONFromURL()
        
        // Cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // self.tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        var rowData: NSDictionary = self.items[indexPath.row] as NSDictionary
        
        // cell.textLabel?.text = rowData["trackName"] as String!
        cell.textLabel?.text = rowData["id"] as String!
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        // var urlString: NSString = rowData["artworkUrl60"] as NSString
        // var imgURL: NSURL = NSURL(string: urlString)!
        
        // Download an NSData representation of the image at the URL
        // var imgData: NSData = NSData(contentsOfURL: imgURL)!
        // cell.imageView?.image = UIImage(data: imgData)
        
        // Get the formatted price string for display in the subtitle
        // var formattedPrice: NSString = rowData["formattedPrice"] as NSString
        var loadInPercent: Int = rowData["percent"] as Int
        var maxCountOfSeats: Int = rowData["max"] as Int
        
        
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

    func loadJSONFromURL() {
        
        var urlPath = "http://www.bib.uni-mannheim.de/bereichsauslastung/index.php?json"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        
        println("Search UB JSON Bereichsauslastung at URL \(url)")
        
        connection.start()
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
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        if jsonResult.count>0 /*&& jsonResult["results"].count>0*/ {
            var results: NSArray = jsonResult["sections"] as NSArray
            self.items = results
            self.tableView.reloadData()
            
        }
    }
    

}
