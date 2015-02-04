//
//  ViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 27.01.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelWebsite: UIView!
    @IBOutlet weak var labelPrimo: UIView!
    @IBOutlet weak var labelNews: UIView!
    @IBOutlet weak var labelSeats: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // custom navigation bar
        
        // red
        // self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        // white
        // self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // custom label
        // border radius
        labelWebsite.layer.cornerRadius = 5;
        labelPrimo.layer.cornerRadius = 5;
        labelNews.layer.cornerRadius = 5;
        labelSeats.layer.cornerRadius = 5;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

