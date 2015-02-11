//
//  ViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 27.01.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        labelWebsite.layer.cornerRadius = 5;
        labelPrimo.layer.cornerRadius = 5;
        labelNews.layer.cornerRadius = 5;
        labelSeats.layer.cornerRadius = 5;
*/        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        
        if (segue.identifier == "showWebsite") {
        
            let destinationViewController = segue.destinationViewController as WebViewController
            var website:NSString = ""
            website = "http://www.bib.uni-mannheim.de/mobile"
            destinationViewController.website = website
            
        }
        
        if (segue.identifier == "showPrimo") {
        
            let destinationViewController = segue.destinationViewController as WebViewController
            var website:NSString = ""
            website = "http://primo.bib.uni-mannheim.de/primo_library/libweb/action/search.do?vid=MAN_MOBILE"
            destinationViewController.website = website
            
        }
        
        
    }
    
    


}

