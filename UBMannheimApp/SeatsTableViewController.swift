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

    var items = ["A", "B"]
    // var url: NSURL = NSURL()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HTTPGetJSON("http://www.bib.uni-mannheim.de/bereichsauslastung/index.php?json") {
            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
            
            if (error != nil) {
                println(error)
            } else {


                if let feed = data["date"] as? NSString {
                    println(feed)
                }
                
                //if let feed = data["sections"] as? NSDictionary {
                //    for f in feed {
                //        println(f)
                //    }
                //}
                
                
                // http://owensd.io/2014/06/18/json-parsing.html
                
                println(".")
                
                let dict = data as Dictionary<String, AnyObject>
                let sections : AnyObject? = dict["sections"]?["section"]
                let collection = sections! as Array<Dictionary<String, AnyObject>>
                for section in collection {
                    let id : AnyObject? = section["id"]
                    let name : AnyObject? = section["name"]
                    let percent : AnyObject? = section["percent"]
                    let max : AnyObject? = section["max"]
                    
                    /*
                    println("Section ID: \(id)")
                    println("Section Name: \(name)")
                    println("Section Seats \(percent)")
                    println("Section Max: \(max)")
                    */
                    
                    var n: NSString = name as NSString!
                    println(n)
                    
                
                }
   
            } // else
  
        }
            
        // println("something")
        
        // Cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.tableView.reloadData()
        
    }
    
    // func loadJSON(data: NSURL) {
    func loadJSON() {
        
        let urlAsString = "http://www.bib.uni-mannheim.de/bereichsauslastung/index.php?json"
        let url = "http://gdata.youtube.com/feeds/api/standardfeeds/most_popular?v=2&alt=json"

        self.items.append("E")
        
        self.items.append("F")
        
        tableView.reloadData()
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Table view data source
     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row] as String
        // cell.detailTextLabel?.text = self.items[indexPath.row] as? String
        return cell

    }
    
    /// /// /// /// 
    
    func HTTPsendRequest(request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            let task = NSURLSession.sharedSession().dataTaskWithRequest(
                request,
                {
                    data, response, error in
                    if error != nil {
                        callback("", error.localizedDescription)
                    } else {
                        callback(
                            NSString(data: data, encoding: NSUTF8StringEncoding)!,
                            nil
                        )
                    }
            })
            
            task.resume()
    }
    func HTTPGet(url: String, callback: (String, String?) -> Void) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        HTTPsendRequest(request, callback)
    }
    func JSONParseDict(jsonString:String) -> Dictionary<String, AnyObject> {
        var e: NSError?
        var data: NSData = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding)!
        var jsonObj = NSJSONSerialization.JSONObjectWithData(
            data,
            options: NSJSONReadingOptions(0),
            error: &e) as Dictionary<String, AnyObject>
        if( e != nil) {
            return Dictionary<String, AnyObject>()
        } else {
            return jsonObj
        }
    }
    func HTTPGetJSON(
        url: String,
        callback: (Dictionary<String, AnyObject>, String?) -> Void) {
            var request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            HTTPsendRequest(request) {
                (data: String, error: String?) -> Void in
                if (error != nil) {
                    callback(Dictionary<String, AnyObject>(), error)
                } else {
                    var jsonObj = self.JSONParseDict(data)
                    callback(jsonObj, nil)
                }
            }
    }

    
    




    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
