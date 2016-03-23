//
//  ConfigController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 25.03.15,
//  last modified on 22.03.16.
//
//  Copyright (c) 2015 Alexander Wagner, UB Mannheim. 
//  All rights reserved.
//

import UIKit

class ConfigController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var DEBUG: Bool = false
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var cacheSwitch: UISwitch!
    @IBOutlet weak var newsPicker: UIPickerView!
    @IBOutlet weak var startupPicker: UIPickerView!
    
    
    let news_elements = ["5","10","15"]
    
    var startup_elements: [AnyObject] = []
    // might be ["Startmenü","Website","Primo","News","Freie Plätze"]
    
    // Initializing Values
    var news_selected: Int = 0
    var news_count: Int = 0
    
    var startup_selected: Int = 0
    var startup_count: Int = 0
    
    var cache_enabled = false
    
    var knews_items: [AnyObject] = []
    
    /*
    // Configuration: Show User Defaults
    
    if (DEBUG) {
    var myArray : Array<Double>! {
        get {
            if let myArray: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey("myArray") {
                print("\(myArray)")
                return myArray as! Array<Double>!
            }
            
            return nil
        }
        set {
            print(myArray)
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "myArray")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    }
    */
    
    
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Initialize Dictionary
        let dict = appDelegate.dict
        startup_elements = dict.objectForKey("labels")?.objectForKey("Modules") as! [AnyObject]
        
        
        // Set Table Layout and Cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // And get rid of empty Lines
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        init_preferences()
        
        // Delete ALL User Preferences (Test)
        // let appDomain = NSBundle.mainBundle().bundleIdentifier!
        // NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
        let kfirstrun: Int? = userDefaults.objectForKey("firstRun") as! Int?
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        
        
        if (DEBUG) {
            print("DEBUG MSG ConfigController__ : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup)")
        }
        
        let knews_items: [AnyObject]? = userDefaults.objectForKey("newsItems") as! [AnyObject]?
        
        if (DEBUG) {
            if((knews_items?.last != nil) && (knews_items!.count > 0)) {
                print("News stack contains \(knews_items!.count) elements")
            }
        }
        
        // #1
        cacheSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        // #2
        // newsPicker = UIPickerView()
        // startupPicker = UIPickerView()
        
        // #3   
        // 2DO: PREFERENCE MANAGER
        
        newsPicker.tag = 1
        startupPicker.tag = 2
        
        newsPicker.dataSource = self
        newsPicker.delegate = self
        
        startupPicker.dataSource = self
        startupPicker.delegate = self
        
        // Layout Form Elements
        
        // Switch
        if(kcache != nil) {
            cacheSwitch.setOn(kcache!, animated: true)
            cache_enabled = (kcache! as Bool?)!
        }
        
        
        // News Picker Selected
        if(knews != nil) {
        
            newsPicker.selectRow(knews!, inComponent: 0, animated: true)
        
            // Set Picker view-news inactive if cache=off
            if (kcache == false) {
                // changed behaviour
                // newsPicker.userInteractionEnabled = false
            } else {
                newsPicker.userInteractionEnabled = true
            }
        }
        
        
        // Startup Selected
        if(kstartup != nil) {
            
            startupPicker.selectRow(kstartup!, inComponent: 0, animated: true)
            
        }
        
    }
    
    func init_preferences() {
        
        var cacheReference: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        if (cacheReference == nil) {
            cacheReference = false
            newsPicker.userInteractionEnabled = false
        } else {
            cacheReference = userDefaults.objectForKey("cacheEnabled") as! Bool?
            newsPicker.userInteractionEnabled = true
        }
        
        var startupReference: Int? = userDefaults.objectForKey("startupWith") as! Int?
        if (startupReference == nil) {
            startupReference = 0
        } else {
            startupReference = userDefaults.objectForKey("startupWith") as! Int?
        }

        var newsReference: Int? = userDefaults.objectForKey("newsCount") as! Int?
        if (newsReference == nil) {
            newsReference = 0
        } else {
            newsReference = userDefaults.objectForKey("newsCount") as! Int?
        }
        
        userDefaults.setObject(cacheReference, forKey: "cacheEnabled")
        userDefaults.setObject(startupReference, forKey: "startupWith")
        userDefaults.setObject(newsReference, forKey: "newsCount")
    
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            
        var count:Int = 0
        
        if pickerView.tag == 1 {
            count = news_elements.count
            // Allocating UserDefaults to Picker1
            news_selected = count
        }
        if pickerView.tag == 2 {
            count = startup_elements.count
            // Allocating UserDefaults to Picker2
            startup_selected = count
        }
        
        return count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var name:String = ""
        // var id:Int = 0
        
        if pickerView.tag == 1 {
            name = news_elements[row]
            self.news_selected = row
        }
        if pickerView.tag == 2 {
            name = startup_elements[row] as! String
            self.startup_selected = row
            
            // userDefaults.setObject(1, forKey: "firstRun")
            // if (DEBUG) { print("Config State of firstRun: ") }
            // if (DEBUG) { print(userDefaults.objectForKey("firstRun")) }
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
    
    // Sizing the components of the UIPickerView
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    // Generating News Entry
    func generateNewsEntry(id: Int) -> [AnyObject] {
        
        let news_id = id
        let date = "01.04.2015"
        let title = "Titel der News No \(news_id)"
        let description = "Beschreibung der News No \(news_id)"
        let link = "http://www.bib.uni-mannheim.de/news/\(news_id)"
        
        let element = [news_id, date, title, description, link] as Array<AnyObject>
        
        return element
    }
    
    @IBAction func deleteAllPreferences() {
        
        // Delete all User Preferences
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
        // Might be the following Keys
        // userDefaults.removeObjectForKey("cacheEnabled")
        // userDefaults.removeObjectForKey("newsCount")
        // userDefaults.removeObjectForKey("startupWith")
        // userDefaults.removeObjectForKey("newsItems")
        
        
        let kfirstrun: Int? = userDefaults.objectForKey("firstRun") as! Int?
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        // let knews_items: [String]? = userDefaults.objectForKey("newsItems") as! [String]?
        
        // if (DEBUG) { print("kcache \(kcache)") }
        // if (DEBUG) { print("knews \(knews)") }
        // if (DEBUG) { print("kstartup \(kstartup)") }
        
        if (DEBUG) {
            print("DEBUG MSG ConfigController__ : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup) [@Action: deleteAllPreferences]")
        }
        
        
        // let knews_items: [AnyObject]? = userDefaults.objectForKey("newsItems") as! [AnyObject]?
        
        
        userDefaults.synchronize()
        
        exit(0)
        
    }
    
    // Change Preferences and reload
    @IBAction func saveConfig() {
        
        let dict = appDelegate.dict
        
        userDefaults.setObject(1, forKey: "firstRun")
        userDefaults.setObject(cache_enabled, forKey: "cacheEnabled")
        userDefaults.setObject(startup_selected, forKey: "startupWith")
        userDefaults.setObject(news_selected, forKey: "newsCount")

        
        let kfirstrun: Int? = userDefaults.objectForKey("firstRun") as! Int?
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        
        if (DEBUG) {
            print("DEBUG MSG ConfigController__ : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup) [@Action: saveConfig]")
        }
        
        // FixMe
        // BEACHTEN : BEI SPEICHERN AUF NETZWERK PRUEFEN (TRUE) UND EINEN ABZUG DER NEWS ERSTELLEN 
        // WENN NICHT HINWEIS ZUM FESTELEGEN BZW;
        // HINWEIS auf NEWSFEED WENN KEIN CACHE UND KEIN NETZ ABER CACHE AKTIV
        
        userDefaults.synchronize()
        
        // reload
        viewDidLoad()
        
        
        // #4
        
        JLToastView.setDefaultValue(
            UIColor.grayColor(),
            forAttributeName: JLToastViewBackgroundColorAttributeName,
            userInterfaceIdiom: .Phone
        )
        
        let toastMsg_savedConfig: String = dict.objectForKey("alertMessages")!.objectForKey("Config")!.objectForKey("savedSettings") as! String
        
        // var config_saved = "Saved settings."
        // if (preferredLanguage == "de-US") {
        //    config_saved = "Einstellungen gespeichert."
        // }
        
        JLToast.makeText(toastMsg_savedConfig).show()
        
    }
    
    // If State of Switch changes saveConfig() too
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
            // Switch is On
            cache_enabled = true
        } else {
            // Switch is Off
            cache_enabled = false
        }
        
        userDefaults.setObject(cache_enabled, forKey: "cacheEnabled")
        
        saveConfig()
    }
  
}