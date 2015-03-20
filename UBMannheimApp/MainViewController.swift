//
//  MainViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 27.01.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var labelWebsite: UIView!
    @IBOutlet weak var labelPrimo: UIView!
    @IBOutlet weak var labelNews: UIView!
    @IBOutlet weak var labelSeats: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelWebsite.layer.cornerRadius = 5;
        labelPrimo.layer.cornerRadius = 5;
        labelNews.layer.cornerRadius = 5;
        labelSeats.layer.cornerRadius = 5;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        var nav = self.navigationController?.navigationBar
        
        // nav?.barStyle = UIBarStyle.Black
        // nav?.tintColor = UIColor.yellowColor()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "icon_32x32")
        imageView.image = image
        // navigationItem.titleView = imageView
        
        // let barButtomItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: "barButtonItemClicked")
        let barButtomItem = UIBarButtonItem(image: UIImage(named: "bar_button"), style: .Plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = barButtomItem
        
        // right Navigation Item, System Icon
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "openConfigDialog"), animated: true)
        
        let tabBarController = UITabBarController()
        
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
    
    func openConfigDialog() {
    
    }
    
    


}

