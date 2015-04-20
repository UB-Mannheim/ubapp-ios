//
//  ConfigController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 25.03.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

class ConfigController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // http://makeapppie.com/tag/uipickerview-in-swift/
    
    @IBOutlet weak var cacheSwitch: UISwitch!
    @IBOutlet weak var startup: UIPickerView!
    @IBOutlet weak var news: UIPickerView!
    
    let news_picker = ["5","10","15"]
    let startup_picker = ["Startmenü","Website","Primo","News","Freie Plätze"]
    
    var news_selected: Int = 0
    var startup_selected: Int = 0
    var cache_enabled = false
/*
var cacheEnabled:Bool = false
var startupWith:Int = 0
var newsCount:Int = 0
*/
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init_preferences()
        
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        
        println("Cache active: \(kcache) :: Startup With ID= \(kstartup) :: Show \(knews) entries")
        // http://www.ioscreator.com/tutorials/uiswitch-tutorial-in-ios8-with-swift
        cacheSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        // news = UIPickerView()
        // startup = UIPickerView()
        
        // http://www.codingexplorer.com/nsuserdefaults-a-swift-introduction/
        
        // 2DO: PREFERENCE MANAGER
        
        news.tag = 1
        startup.tag = 2
        
        news.dataSource = self
        news.delegate = self
        
        startup.dataSource = self
        startup.delegate = self
        
        // layout form elements
        
        // switch
        cacheSwitch.setOn(kcache!, animated: true)
        
        // news picker selected
        news.selectRow(knews!, inComponent: 0, animated: true)
        
        // set picker view-news inactive if cache=off
        if (kcache == false) {
            news.userInteractionEnabled = false
        } else {
            news.userInteractionEnabled = true
        }
        
        // startup selected
        startup.selectRow(kstartup!, inComponent: 0, animated: true)
    }
    
    /*
    func preferences_set() -> Bool {
        
        var already_set = false
        
        let cache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let news: Int? = userDefaults.objectForKey("startupWith") as! Int?
        let startup: Int? = userDefaults.objectForKey("newsCount") as! Int?

        if(cache != nil || news == nil || startup == nil) {
            already_set = true
        }
        
        return already_set
    }*/
    
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var count:Int = 0
        
        if pickerView.tag == 1 {
            count = news_picker.count
            // zuweisung userDefaults Picker1
            news_selected = count
        }
        if pickerView.tag == 2 {
            count = startup_picker.count
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
            name = news_picker[row]
            self.news_selected = row
        }
        if pickerView.tag == 2 {
            name = startup_picker[row]
            self.startup_selected = row
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
    //selfmade and probably senceless
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> Int! {
        
        var selected = row
        
        return selected
    }
    */
    
    @IBAction func saveConfig() {
        
        
        
        // EINFACH PREFS ÄNDENR UND NEU LADEN
        
        // Dann neustarten und Testen
        // :)
        
        userDefaults.setObject(cache_enabled, forKey: "cacheEnabled")
        userDefaults.setObject(startup_selected, forKey: "startupWith")
        userDefaults.setObject(news_selected, forKey: "newsCount")
        userDefaults.synchronize()
        
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
        myLabel.text = news_picker[row]
    }
    */
}