//
//  NewFeedViewController.swift
//  RSSwift
//
//  Created by Arled Kola on 27/10/2014.
//  Copyright (c) 2014 Arled. All rights reserved.
//
//  Last modified by Alexander Wagner on 22.03.2016
//
//

import UIKit

class NewFeedViewController: UIViewController {
    
    // Testing NewsFeed via RSSWift
    // ?non-productive?

    @IBOutlet var textFieldNewFeedUrl: UITextField!
    
    // Reusable member
    var onDataAvailable : ((_ data: URL) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneTapped(_ sender: AnyObject) {
        
        // Send new Url
        self.onDataAvailable?(URL(string: textFieldNewFeedUrl.text!)!)
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
