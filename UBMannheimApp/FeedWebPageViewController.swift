//
//  FeedWebPageViewController.swift
//  RSSwift
//
//  Created by Arled Kola on 27/10/2014.
//  Copyright (c) 2014 Arled. All rights reserved.
//
//  Last modified by Alexander Wagner on 22.03.2016
//
//

import UIKit

class FeedWebPageViewController: UIViewController {
    
    var DEBUG: Bool = false
    // if (DEBUG) {}
    
    var feedURL = ""

    @IBOutlet var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myWebView.loadRequest(URLRequest(url: URL(string: feedURL)!))

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
