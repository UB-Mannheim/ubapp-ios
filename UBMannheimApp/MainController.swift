//
//  MainController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 26.03.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

class MainController: UIViewController {

    // used grid
    // http://swiftiostutorials.com/tutorial-using-uicollectionview-uicollectionviewflowlayout
    
    // alternative grid
    // http://www.raywenderlich.com/83130/beginning-auto-layout-tutorial-swift-part-2
    
    @IBOutlet weak var collectionView: UICollectionView!

    var menuItems: [MenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMenuItems()
        collectionView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var nav = self.navigationController?.navigationBar
        
        // nav?.barStyle = UIBarStyle.Black
        // nav?.tintColor = UIColor.yellowColor()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "icon_32x32")
        imageView.image = image
        // navigationItem.titleView = imageView
        
        // let barButtomItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: "barButtonItemClicked")
        let barButtomItem = UIBarButtonItem(image: UIImage(named: "bar_button"), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = barButtomItem
        
        // right Navigation Item, System Icon
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(MainController.openConfigDialog)), animated: true)
        
        // delete
        // let tabBarController = UITabBarController()
        
    }
    
    fileprivate func initMenuItems() {
        
        var items = [MenuItem]()
        
        let inputFile = Bundle.main.path(forResource: "items", ofType: "plist")
        
        let inputDataArray = NSArray(contentsOfFile: inputFile!)
        
        for inputItem in inputDataArray as! [Dictionary<String, String>] {
            let menuItem = MenuItem(dataDictionary: inputItem)
            items.append(menuItem)
        }
        
        menuItems = items
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuItemCollectionViewCell", for: indexPath)as! MenuItemCollectionViewCell
        
        cell.setMenuItem(menuItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
    
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
        alert.addAction(alertAction)
        
        // self.presentViewController(alert, animated: true, completion: nil)
        
        
        switch(indexPath.item) {
        case 0: showWebView("website")
                break
        case 1: showWebView("primo")
                break
        case 2: let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewsView") as! FeedTableViewController
        self.navigationController?.pushViewController(homeViewController, animated: true)
                break
        case 3: let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "SeatsView") as! SeatsTableViewController
        self.navigationController?.pushViewController(homeViewController, animated: true)
                break
            
        default: print("default action")
        }
    }
    
    func showWebView(_ destination: String) {
        
        let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebView") as! WebViewController
        
        var url: NSString = ""
        
        if (destination=="website") {
            url = "http://www.bib.uni-mannheim.de/mobile"
        }
        
        if (destination=="primo") {
            url = "http://primo.bib.uni-mannheim.de/primo_library/libweb/action/search.do?vid=MAN_MOBILE"
        }
        
        webViewController.website = url
        
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func showSeats() {
        
        let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SeatsView") as! TableViewController
        
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    /*
    @IBAction func showConfigView() {
        
        let confViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ConfigView") as ConfigController
        
        self.navigationController?.pushViewController(confViewController, animated: true)
    }
    
    @IBAction func showDBView() {
        
        let dbViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DBView") as DBViewController
        
        self.navigationController?.pushViewController(dbViewController, animated: true)
    }
    */
    
    // reservierter platz fuer bild
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let picDimensionX = self.view.frame.size.width / 2.5 // 16.0
        let picDimensionY = self.view.frame.size.height / 2.5
        
        // 2do
        // check and return minimum sizes
        
        return CGSize(width: picDimensionX, height: picDimensionY)
    }
    
    // aussenabstand des grids
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = self.view.frame.size.width / 14.0 // 14.0
        // return UIEdgeInsets(top: 0, left: leftRightInset, bottom: 0, right: leftRightInset)
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // http://stackoverflow.com/questions/27817055/orientation-change-in-swift-height-change-and-uibutton-hide-on-landscape
        
        //  Add custom view sizing constraints here
        
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        if orientation.isLandscape {
            viewDidLoad()
        }
        
        if orientation.isPortrait {
            viewDidLoad()
        }
    }
    
    /*
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            viewDidLoad()
        } else {
            viewDidLoad()
        }
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        
        if (segue.identifier == "showWebsite") {
            
            let destinationViewController = segue.destination as! WebViewController
            var website:NSString = ""
            website = "http://www.bib.uni-mannheim.de/mobile"
            destinationViewController.website = website
            
        }
        
        if (segue.identifier == "showPrimo") {
            
            let destinationViewController = segue.destination as! WebViewController
            var website:NSString = ""
            website = "http://primo.bib.uni-mannheim.de/primo_library/libweb/action/search.do?vid=MAN_MOBILE"
            destinationViewController.website = website
            
        }
        
        if (segue.identifier == "showNews") {
            
            let destinationViewController = segue.destination as! TableViewController
            destinationViewController.viewDidLoad()
            
        }
        
        if (segue.identifier == "showSeats") {
            
            let destinationViewController = segue.destination as! ViewController
            destinationViewController.viewDidLoad()
            
        }
    }
    
    func openConfigDialog() {
        
    }

}
