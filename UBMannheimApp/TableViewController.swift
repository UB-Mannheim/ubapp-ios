//
//  TableViewController.swift
//  UBMannheimApp
//
//  Created by Universitätsbibliothek Mannheim on 11.02.15.
//  Copyright (c) 2015 Universitätsbibliothek Mannheim. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, XMLParserDelegate {

    var parser = XMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var fdescription = NSMutableString()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 70
        
        feeds = []
        // var url: NSURL = NSURL(fileURLWithPath: "http://blog.bib.uni-mannheim.de/Aktuelles/?feed=rss2&cat=4")!
        let url: URL = URL(fileURLWithPath: "http://www.skysports.com/rss/0,20514,11661,00.xml")
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
            
        element = elementName as NSString
            
        // instantiate feed properties
        if(element as NSString).isEqual(to: "item") {
        
            elements = NSMutableDictionary()
            elements = [:]
            ftitle = NSMutableString()
            ftitle = ""
            link = NSMutableString()
            link = ""
            fdescription = NSMutableString()
            fdescription = ""
                
        }
    
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // process feed elements
        if(elementName as NSString).isEqual(to: "item") {
            
            if ftitle != "" {
                elements.setObject(ftitle, forKey: "title" as NSCopying)
            }
            
            if link != "" {
                elements.setObject(link, forKey: "link" as NSCopying)
            }
            
            if fdescription != "" {
                elements.setObject(fdescription, forKey: "description" as NSCopying)
            }
            
            feeds.add(elements)
            
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String?) {
        
        if element.isEqual(to: "title") {
            ftitle.append(string!)
        } else if element.isEqual(to: "link") {
            link.append(string!)
        } else if element.isEqual(to: "description") {
            fdescription.append(string!)
        }
    
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return feeds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 

        cell.textLabel?.text = (feeds.object(at: indexPath.row) as AnyObject).object(forKey: "title") as? String
        cell.detailTextLabel?.numberOfLines = 3
        cell.detailTextLabel?.text = (feeds.object(at: indexPath.row) as AnyObject).object(forKey: "description") as? String

        return cell
    }

}
