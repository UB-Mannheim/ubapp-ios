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

    let news_picker = ["5","10","15"]
    let startup_picker = ["Startmenü","Website","Primo","News","Freie Plätze"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
        if pickerView.tag == 2 {
            name = startup_picker[row]
        }
        
        return name
        
    }
    
    /*
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myLabel.text = news_picker[row]
    }
    */
}