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
    
    @IBOutlet weak var news: UIPickerView!
    @IBOutlet weak var startup: UIPickerView!
    
    @IBOutlet weak var cacheSwitch: UISwitch!
    
    let news_picker = ["5","10","15"]
    let startup_picker = ["Startmenü","Website","Primo","News","Freie Plätze"]
    
    var news_selected: Int = 0
    var startup_selected: Int = 0
    var cache_enabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // http://www.ioscreator.com/tutorials/uiswitch-tutorial-in-ios8-with-swift
        cacheSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        // news = UIPickerView()
        // startup = UIPickerView()
        
        news.tag = 1
        startup.tag = 2
        
        news.dataSource = self
        news.delegate = self
        
        startup.dataSource = self
        startup.delegate = self
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var count = 0
        
        if pickerView.tag == 1 {
            count = news_picker.count
        }
        if pickerView.tag == 2 {
            count = startup_picker.count
        }
        
        return count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        var name = ""
        
        if pickerView.tag == 1 {
            name = news_picker[row]
            self.news_selected = row
        }
        if pickerView.tag == 2 {
            name = startup_picker[row]
            self.startup_selected = row
        }
        
        return name
        
    }
    
    /*
    //selfmade and probably senceless
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> Int! {
        
        var selected = row
        
        return selected
    }
    */
    
    @IBAction func showConfig() {
        
        
        let cache_on = cache_enabled
        let news_entries = self.news_selected
        let startup = self.startup_selected
        let m = "Einstellungen auswgewählt: \(cache_on) : \(news_entries) : \(startup)"
        
        let alertController = UIAlertController(title: "Fehler", message: m, preferredStyle: .Alert)
        
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
        
        // alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
            // myTextField.text = "The Switch is On"
            cache_enabled = true
        } else {
            // myTextField.text = "The Switch is Off"
            cache_enabled = false
        }
    }
    
    /*
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myLabel.text = news_picker[row]
    }
    */
}