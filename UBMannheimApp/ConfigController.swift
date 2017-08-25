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
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
    
    
    let userDefaults:UserDefaults=UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Initialize Dictionary
        let dict = appDelegate.dict
        startup_elements = (dict.object(forKey: "labels") as AnyObject).object(forKey: "Modules") as! [AnyObject]
        
        
        // Set Table Layout and Cell height.
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // And get rid of empty Lines
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        init_preferences()
        
        // Delete ALL User Preferences (Test)
        // let appDomain = NSBundle.mainBundle().bundleIdentifier!
        // NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
        let kfirstrun: Int? = userDefaults.object(forKey: "firstRun") as! Int?
        let kcache: Bool? = userDefaults.object(forKey: "cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.object(forKey: "newsCount") as! Int?
        let kstartup: Int? = userDefaults.object(forKey: "startupWith") as! Int?
        
        
        if (DEBUG) {
            print("DEBUG MSG ConfigController__ : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup)")
        }
        
        let knews_items: [AnyObject]? = userDefaults.object(forKey: "newsItems") as! [AnyObject]?
        
        if (DEBUG) {
            if((knews_items?.last != nil) && (knews_items!.count > 0)) {
                print("News stack contains \(knews_items!.count) elements")
            }
        }
        
        // #1
        cacheSwitch.addTarget(self, action: #selector(ConfigController.stateChanged(_:)), for: UIControlEvents.valueChanged)
        
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
                newsPicker.isUserInteractionEnabled = true
            }
        }
        
        
        // Startup Selected
        if(kstartup != nil) {
            
            startupPicker.selectRow(kstartup!, inComponent: 0, animated: true)
            
        }
        
    }
    
    func init_preferences() {
        
        var cacheReference: Bool? = userDefaults.object(forKey: "cacheEnabled") as! Bool?
        if (cacheReference == nil) {
            cacheReference = false
            newsPicker.isUserInteractionEnabled = false
        } else {
            cacheReference = userDefaults.object(forKey: "cacheEnabled") as! Bool?
            newsPicker.isUserInteractionEnabled = true
        }
        
        var startupReference: Int? = userDefaults.object(forKey: "startupWith") as! Int?
        if (startupReference == nil) {
            startupReference = 0
        } else {
            startupReference = userDefaults.object(forKey: "startupWith") as! Int?
        }

        var newsReference: Int? = userDefaults.object(forKey: "newsCount") as! Int?
        if (newsReference == nil) {
            newsReference = 0
        } else {
            newsReference = userDefaults.object(forKey: "newsCount") as! Int?
        }
        
        userDefaults.set(cacheReference, forKey: "cacheEnabled")
        userDefaults.set(startupReference, forKey: "startupWith")
        userDefaults.set(newsReference, forKey: "newsCount")
    
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
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
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30.0
    }
    
    // Generating News Entry
    func generateNewsEntry(_ id: Int) -> [AnyObject] {
        
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
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        
        // Might be the following Keys
        // userDefaults.removeObjectForKey("cacheEnabled")
        // userDefaults.removeObjectForKey("newsCount")
        // userDefaults.removeObjectForKey("startupWith")
        // userDefaults.removeObjectForKey("newsItems")
        
        
        let kfirstrun: Int? = userDefaults.object(forKey: "firstRun") as! Int?
        let kcache: Bool? = userDefaults.object(forKey: "cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.object(forKey: "newsCount") as! Int?
        let kstartup: Int? = userDefaults.object(forKey: "startupWith") as! Int?
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
        
        userDefaults.set(1, forKey: "firstRun")
        userDefaults.set(cache_enabled, forKey: "cacheEnabled")
        userDefaults.set(startup_selected, forKey: "startupWith")
        userDefaults.set(news_selected, forKey: "newsCount")

        
        let kfirstrun: Int? = userDefaults.object(forKey: "firstRun") as! Int?
        let kcache: Bool? = userDefaults.object(forKey: "cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.object(forKey: "newsCount") as! Int?
        let kstartup: Int? = userDefaults.object(forKey: "startupWith") as! Int?
        
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
        /*
        JLToastView.setDefaultValue(
            UIColor.gray,
            forAttributeName: JLToastViewBackgroundColorAttributeName,
            userInterfaceIdiom: .phone
        )
        
        let toastMsg_savedConfig: String = ((dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "Config")! as AnyObject).object(forKey: "savedSettings") as! String
        
        // var config_saved = "Saved settings."
        // if (preferredLanguage == "de-US") {
        //    config_saved = "Einstellungen gespeichert."
        // }
        
        JLToast.makeText(toastMsg_savedConfig).show()
        */
        
        // #4 
        
        let toastMsg_savedConfig: String = ((dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "Config")! as AnyObject).object(forKey: "savedSettings") as! String
        
        let appearance = ToastView.appearance()
        appearance.textInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        appearance.cornerRadius = 15
        
        Toast(text: toastMsg_savedConfig).show()
    }
    
    // If State of Switch changes saveConfig() too
    func stateChanged(_ switchState: UISwitch) {
        if switchState.isOn {
            // Switch is On
            cache_enabled = true
        } else {
            // Switch is Off
            cache_enabled = false
        }
        
        userDefaults.set(cache_enabled, forKey: "cacheEnabled")
        
        saveConfig()
    }
  
}
