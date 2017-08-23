//
//  ViewController.swift
//  SelfSizingDemo
//
//  Created by Simon Ng on 4/9/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//
//  Last modified on 23.03.2016 by Alexander Wagner
//
//

import UIKit

class Help2ViewController: UITableViewController {
    
    var DEBUG: Bool = false
    // if (DEBUG) {
    
    // var hotelNames:[String] = []
    
    var items:[String] = []
    
    let userDefaults:UserDefaults=UserDefaults.standard
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = appDelegate.dict
        
        let website_title: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Help")! as AnyObject).object(forKey: "website_title") as! String
        let website_sub: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Help")! as AnyObject).object(forKey: "website_subtitle") as! String
        
        let primo_title: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Help")! as AnyObject).object(forKey: "primo_title") as! String
        let primo_sub: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Help")! as AnyObject).object(forKey: "primo_subtitle") as! String
        
        let news_title: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Help")! as AnyObject).object(forKey: "news_title") as! String
        let news_sub: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Help")! as AnyObject).object(forKey: "news_subtitle") as! String
        
        let seats_title: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Help")! as AnyObject).object(forKey: "seats_title") as! String
        let seats_sub: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Help")! as AnyObject).object(forKey: "seats_subtitle") as! String
        
        let config_title: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Help")! as AnyObject).object(forKey: "config_title") as! String
        let config_sub: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Help")! as AnyObject).object(forKey: "config_subtitle") as! String
        
        self.items = [
            String(describing: ["image": "website_bk", "title": website_title, "descr": website_sub]),
            String(describing: ["image": "primo_bk", "title": primo_title, "descr": primo_sub]),
            String(describing: ["image": "news_bk", "title": news_title, "descr": news_sub]),
            String(describing: ["image": "seats_bk", "title": seats_title, "descr": seats_sub]),
            String(describing: ["image": "config_bk", "title": config_title, "descr": config_sub])
        ]
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        let kfirstrun: Int? = userDefaults.object(forKey: "firstRun") as! Int?
        let kcache: Bool? = userDefaults.object(forKey: "cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.object(forKey: "newsCount") as! Int?
        let kstartup: Int? = userDefaults.object(forKey: "startupWith") as! Int?
        if (DEBUG) { print("DEBUG MSG HelpViewController_: FirstRun = \(String(describing: kfirstrun)) | Cache = \(String(describing: kcache)) | News = \(String(describing: knews)) | Startup \(String(describing: kstartup))") }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return hotels.count
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        /*
        let title = self.items[indexPath.row]["title"]
        let subtitle = self.items[indexPath.row]["descr"]
        */
        
        let elements: NSArray = self.items[indexPath.row] as! NSArray
        let title: NSString = elements[1] as! NSString
        let subtitle: NSString = elements[2] as! NSString
        
        // let title = "swift3 title"
        // let subtitle = "swift3 subtitle"
         
        cell.nameLabel?.text = title as String?
        cell.addressLabel?.text = subtitle as String?
        // cell.imageView!.image = UIImage(named: self.items[indexPath.row]["image"] as! String)
        
        let image: NSString = elements[0] as! NSString
        cell.imageView!.image = UIImage(named: image as! String)
        
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
        
        let dict = appDelegate.dict
        let help_title: String = ((dict.object(forKey: "labels")! as AnyObject).object(forKey: "Help")! as AnyObject).object(forKey: "help_title") as! String
        
        headerCell.textLabel?.text = help_title
        headerCell.backgroundColor = uicolorFromHex(0xf7f7f7)
        
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55.0
    }
}

