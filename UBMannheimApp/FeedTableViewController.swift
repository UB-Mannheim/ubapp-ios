//
//  FeedTableViewController.swift
//  RSSwift
//
//  Created by Arled Kola on 20/09/2014.
//  Copyright (c) 2014 Arled. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate {

    var myFeed : NSArray = []
    var url: NSURL = NSURL()
    
    // UIRefreshControl
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        loadRss(url);
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // if pulled down, refresh
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        // Cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Set feed url. http://www.formula1.com/rss/news/latest.rss
        // url = NSURL(string: "http://www.skysports.com/rss/0,20514,11661,00.xml")!
        url = NSURL(string: "http://blog.bib.uni-mannheim.de/Aktuelles/?feed=rss2&cat=4")!
        // url = NSURL(string: "http://blog.bib.uni-mannheim.de/Aktuelles_Ex/?feed=rss2&cat=4")!
        // Call custom function.
        loadRss(url);

    }
    
    func loadRss(data: NSURL) {
        // XmlParserManager instance/object/variable
        var myParser : XmlParserManager = XmlParserManager.alloc().initWithURL(data) as! XmlParserManager
        // Put feed in array
        myFeed = myParser.feeds
        
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
            
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            // let selectedFeedURL: String = feeds[indexPath.row].objectForKey("link") as String
            let selectedFTitle: String = myFeed[indexPath.row].objectForKey("title") as! String
            // let selectedFContent: String = myFeed[indexPath.row].objectForKey("description") as String
            let selectedFContent: String = myFeed[indexPath.row].objectForKey("content:encoded") as! String
            let selectedFURL: String = myFeed[indexPath.row].objectForKey("link") as! String
            
            // Instance of our feedpageviewcontrolelr
            let fpvc: FeedPageViewController = segue.destinationViewController as! FeedPageViewController

            fpvc.selectedFeedTitle = selectedFTitle
            fpvc.selectedFeedFeedContent = selectedFContent
            // println(selectedFContent)
            fpvc.selectedFeedURL = selectedFURL
            
        }
    }

    /*
    func imageFromRSSContent(content: String) -> Void {
        
        var image: String = String()
        var content: String = content
        
        if let match = content.rangeOfString("<a\\s(?=.*?)[^>]*>$", options: .RegularExpressionSearch) {
            println("\(content) with image")
        }

    }
    */

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeed.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        // Feed Image
        // cell.imageView?.image = UIImage (named: "news_pre")
        
        // Feeds dictionary.
        var dict : NSDictionary! = myFeed.objectAtIndex(indexPath.row) as! NSDictionary
        
        // Set cell properties.
        cell.textLabel?.text = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String
        
        // It seems that cell.textLabel?.text is no longer an optionional.
        // If the above line throws an error then comment it out and uncomment the below line.
        //cell.textLabel?.text = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String

        var formattedFeedTitle = myFeed.objectAtIndex(indexPath.row).objectForKey("pubDate") as? String
        
        var date: String = formattedFeedTitle!
        let stringLength = count(date)
        let substringIndex = stringLength - 12
        date = date.substringToIndex(advance(date.startIndex, substringIndex))
        
        cell.detailTextLabel?.text = date
        
        var content = myFeed.objectAtIndex(indexPath.row).objectForKey("content:encoded") as? String
        // println("FeedTableView: "+content!)
        
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
}
