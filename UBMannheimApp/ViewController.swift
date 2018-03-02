//
//  ViewController.swift
//  UBMannheimApp
//
//  Created by Universitätsbibliothek Mannheim on 27.01.15.
//  Copyright (c) 2015 Universitätsbibliothek Mannheim. All rights reserved.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        let destinationViewController = segue.destination as! WebViewController
        
        var website:NSString = ""
        let langStr = Locale.current.languageCode
        
        if (segue.identifier == "showWebsite") {
            
            //website = "http://www.bib.uni-mannheim.de/mobile"
            if (langStr == "de") {
                website = "https://www.bib.uni-mannheim.de/"
            } else {
                website = "https://www.bib.uni-mannheim.de/en/"
            }
        }
        
        if (segue.identifier == "showPrimo") {
        
            //website = "http://primo.bib.uni-mannheim.de/primo_library/libweb/action/search.do?vid=MAN_MOBILE"
            if (langStr == "de") {
                website = "http://primo.bib.uni-mannheim.de/primo-explore/search?vid=MAN_UB&lang=de_DE"
            } else {
                website = "http://primo.bib.uni-mannheim.de/primo-explore/search?vid=MAN_UB&lang=en_US"
            }
        }
            
        destinationViewController.website = website
        
    }


}

