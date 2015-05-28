
//
//  ConfigController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 25.03.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

class ConfigController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // http://makeapppie.com/tag/uipickerview-in-swift/
    
    @IBOutlet weak var cacheSwitch: UISwitch!
    @IBOutlet weak var newsPicker: UIPickerView!
    @IBOutlet weak var startupPicker: UIPickerView!
    
    let news_elements = ["5","10","15"]
    let startup_elements = ["Startmenü","Website","Primo","News","Freie Plätze"]
    
    // alles nur temoporaere - oder?
    var news_selected: Int = 0
    var news_count: Int = 0
    
    var startup_selected: Int = 0
    var startup_count: Int = 0
    
    var cache_enabled = false
    
    var knews_items: [AnyObject] = []
    
    /*
    var myArray : Array<Double>! {
        get {
            if let myArray: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey("myArray") {
                println("\(myArray)")
                return myArray as! Array<Double>!
            }
            
            return nil
        }
        set {
            println(myArray)
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "myArray")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    */
    
    
/*
var cacheEnabled:Bool = false
var startupWith:Int = 0
var newsCount:Int = 0
*/
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad ....................................................")
        
        //table layout
        // Cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // get rid of empty lines
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        
        // init_preferences()
        
        // Delete ALL USER PREFERENCES
        // let appDomain = NSBundle.mainBundle().bundleIdentifier!
        // NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
        
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        // let knews_items: [String]? = userDefaults.objectForKey("newsItems") as! [String]?
        
        println("kcache \(kcache)")
        println("knews \(knews)")
        println("kstartup \(kstartup)")
        
        let knews_items: [AnyObject]? = userDefaults.objectForKey("newsItems") as! [AnyObject]?
        
        println("Cache active: \(kcache) :: Startup With ID= \(kstartup) :: Show \(knews) entries")
        
        if((knews_items?.last != nil) && (knews_items!.count > 0)) {
            // println("News stack contains \(knews_items!.count) elements")
        }
        
        // http://www.ioscreator.com/tutorials/uiswitch-tutorial-in-ios8-with-swift
        cacheSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        // newsPicker = UIPickerView()
        // startupPicker = UIPickerView()
        
        // http://www.codingexplorer.com/nsuserdefaults-a-swift-introduction/
        
        // 2DO: PREFERENCE MANAGER
        
        newsPicker.tag = 1
        startupPicker.tag = 2
        
        newsPicker.dataSource = self
        newsPicker.delegate = self
        
        startupPicker.dataSource = self
        startupPicker.delegate = self
        
        // layout form elements
        
        // switch
        if(kcache != nil) {
            cacheSwitch.setOn(kcache!, animated: true)
            cache_enabled = (kcache! as Bool?)!
        }
        
        
        // news picker selected
        
        if(knews != nil) {
        
            newsPicker.selectRow(knews!, inComponent: 0, animated: true)
        
            // set picker view-news inactive if cache=off
            if (kcache == false) {
                newsPicker.userInteractionEnabled = false
            } else {
                newsPicker.userInteractionEnabled = true
            }
        }
        
        
        // startup selected
        
        if(kstartup != nil) {
            
            startupPicker.selectRow(kstartup!, inComponent: 0, animated: true)
        
        }
        
    }
    
    /*
    func preferences_set() -> Bool {
        
        var already_set = false
        
        let cache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let newsPicker: Int? = userDefaults.objectForKey("startupWith") as! Int?
        let startupPicker: Int? = userDefaults.objectForKey("newsCount") as! Int?

        if(cache != nil || newsPicker == nil || startupPicker == nil) {
            already_set = true
        }
        
        return already_set
    }*/
    
    // später auslagern in initConfigClass ... (+FeedTableVIewController, firstRunReference)
    // ausgelagert in MainMenuController
    /*
    func init_preferences() {
        
        var cacheReference: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        if (cacheReference == nil) {
            cacheReference = false
        } else {
            cacheReference = userDefaults.objectForKey("cacheEnabled") as! Bool?
        }
        
        var startupReference: Int? = userDefaults.objectForKey("startupWith") as! Int?
        if (startupReference == nil) {
            startupReference = 0
        } else {
            startupReference = userDefaults.objectForKey("startupWith") as! Int?
        }

        var newsReference: Int? = userDefaults.objectForKey("newsCount") as! Int?
        if (newsReference == nil) {
            newsReference = 5
        } else {
            newsReference = userDefaults.objectForKey("newsCount") as! Int?
        }
        
        userDefaults.setObject(cacheReference, forKey: "cacheEnabled")
        userDefaults.setObject(startupReference, forKey: "startupWith")
        userDefaults.setObject(newsReference, forKey: "newsCount")
    
    }
    */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            
        var count:Int = 0
        
        if pickerView.tag == 1 {
            count = news_elements.count
            // zuweisung userDefaults Picker1
            news_selected = count
        }
        if pickerView.tag == 2 {
            count = startup_elements.count
            // Zuweisung userDefaults Picker2
            startup_selected = count
        }
        
        // self.newsCount = count
        return count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        var name:String = ""
        var id:Int = 0
        
        if pickerView.tag == 1 {
            name = news_elements[row]
            self.news_selected = row
        }
        if pickerView.tag == 2 {
            name = startup_elements[row]
            self.startup_selected = row
            
            // userDefaults.setObject(1, forKey: "firstRun")
            // print("Config State of firstRun: ")
            // println(userDefaults.objectForKey("firstRun"))
        }
        
        /*
        switch name {
            case "Startmenü": id=0
            case "Website": id=1
            case "Primo": id=2
            case "News": id=3
            case "Freie Plätze": id=4
            default: id=0
        }
        
        // self.startupWith = id
        */
        
        return name
        
    }
    /*
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = view as! UILabel!
        
        if(pickerView.tag == 1) {
            
            if view == nil {  //if no label there yet
                pickerLabel = UILabel()
                
                //color  and center the label's background
                let hue = CGFloat(row)/CGFloat(news_elements.count)
                pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness:1.0, alpha: 1.0)
                pickerLabel.textAlignment = .Center
                
            }
            let titleData = news_elements[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
            pickerLabel!.attributedText = myTitle
            
        }
        if(pickerView.tag == 2) {
        
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            
            //color  and center the label's background
            let hue = CGFloat(row)/CGFloat(startup_elements.count)
            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness:1.0, alpha: 1.0)
            pickerLabel.textAlignment = .Center
            
        }
        let titleData = startup_elements[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        }
        
        return pickerLabel
        
    }
*/
    
    //size the components of the UIPickerView
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    /*
    //selfmade and probably senceless
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> Int! {
        
        var selected = row
        
        return selected
    }
    */
    
    func generateNewsEntry(id: Int) -> [AnyObject] {
        
        var news_id = id
        var date = "01.04.2015"
        var title = "Titel der News No \(news_id)"
        var description = "Beschreibung der News No \(news_id)"
        var link = "http://www.bib.uni-mannheim.de/news/\(news_id)"
        
        var element = [news_id, date, title, description, link] as Array<AnyObject>
        
        return element
    }
    
    @IBAction func deleteAllPreferences() {
        
    }
    
    
    @IBAction func saveConfig() {
        
        // EINFACH PREFS ÄNDENR UND NEU LADEN
        
        // Dann neustarten und Testen
        // :)
        
        userDefaults.setObject(cache_enabled, forKey: "cacheEnabled")
        userDefaults.setObject(startup_selected, forKey: "startupWith")
        userDefaults.setObject(news_selected, forKey: "newsCount")

/* NO NEWS TODAY :) TEMP FOR PREFERENCE CHECK
        
        // ggf News Items auch hier speichern?
        var nitems = [AnyObject]()
        
        // auslesen und zurückspeichern der news
        if (userDefaults.objectForKey("newsItems")?.count <= 0) {
            var tmp = generateNewsEntry(1)
            nitems.append(tmp)

        } else {
            nitems = (userDefaults.objectForKey("newsItems") as! [NSArray]?)!
            if(nitems.count > 0) {
                // nitems.append("test \(nitems.count+1)")
                // var tmp = ["Date", "Title of News", "Description", "Link", "href"] as Array<AnyObject>
                var tmp = generateNewsEntry(nitems.count)
                nitems.append(tmp)
            }
        }
        
        userDefaults.setObject(nitems, forKey: "newsItems")
*/
        userDefaults.synchronize()
        
// println("News ITEMS: \(nitems)")
        
        // reload
        viewDidLoad()
        
        /*
        let cache_on = cache_enabled
        let news_entries = self.news_selected
        let startup = self.startup_selected
        let m = "Einstellungen auswgewählt: \(cache_on) : \(news_entries) : \(startup)"
        let m2 = "vorliegende Preferenzen: \(cacheEnabled) : \(newsCount) : \(startupWith)"
        
        
        // let alertController = UIAlertController(title: "Chosen", message: m, preferredStyle: .Alert)
        let alertController2 = UIAlertController(title: "Preferences", message: m2, preferredStyle: .Alert)
        /*
        let cancelAction = UIAlertAction(title: "Zurück", style: .Cancel) { (action) in
            // MainView set as storyboard ID of MainViewController
            let cfgViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ConfigView") as ConfigController
            self.navigationController?.pushViewController(cfgViewController, animated: true)
        }
        */
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
            self.viewDidLoad()
        }
        
        // // alertController.addAction(cancelAction)
        // alertController.addAction(okAction)
        alertController2.addAction(okAction)
        
        // self.presentViewController(alertController, animated: true, completion: nil)
        self.presentViewController(alertController2, animated: true, completion: nil)
        
        */
    }
    
    // nur wenn statechanged ... 2do auch sonst speichern saveConfig()
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
            // myTextField.text = "The Switch is On"
            cache_enabled = true
            // self.cacheEnabled = true
        } else {
            // myTextField.text = "The Switch is Off"
            cache_enabled = false
            // self.cacheEnabled = false
        }
        
        userDefaults.setObject(cache_enabled, forKey: "cacheEnabled")
        
        saveConfig()
    }
    
    /*
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myLabel.text = news_elements[row]
    }
    */
}