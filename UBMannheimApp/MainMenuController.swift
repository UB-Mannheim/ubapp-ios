//
//  MainMenuController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 09.04.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//

import UIKit

class MainMenuController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // exkurs: tutorial adaptive layout
    // https://youtu.be/E3glNbNnokw
    
    
    // this.
    // http://www.brianjcoleman.com/tutorial-collection-view-using-swift/
    
    @IBOutlet var collectionView: UICollectionView!
    
    var menuItems: [MenuItem] = []
    
    /*
    var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var picDimensionX: CGFloat = 0.0
    var picDimensionY: CGFloat = 0.0
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        initMenuItems()
        
        /*
        var currentDevice: UIDevice = UIDevice.currentDevice()
        var orientation: UIDeviceOrientation = currentDevice.orientation
        println(orientation)
        */
        
        // http://stackoverflow.com/questions/25666269/ios8-swift-how-to-detect-orientation-change
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        rotated()
        /*
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 80, left: 20, bottom: 20, right: 20)
        let picDimensionX = self.view.frame.size.width / 2.5
        let picDimensionY = self.view.frame.size.height / 2.5
        
        layout.itemSize = CGSize(width: picDimensionX, height: picDimensionY)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        */
        
        // collectionView.reloadData() ?
    }
    
    override func viewDidAppear(animated: Bool) {
        var nav = self.navigationController?.navigationBar
        
        // Logo and Upper Right MenuButton
        //
        
        // nav?.barStyle = UIBarStyle.Black
        // nav?.tintColor = UIColor.yellowColor()
        
        /*
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "icon_32x32")
        imageView.image = image
        // navigationItem.titleView = imageView
        */
        
        // let barButtomItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: "barButtonItemClicked")
        
        let barButtomItem = UIBarButtonItem(image: UIImage(named: "bar_button"), style: .Plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = barButtomItem
        
        // right Navigation Item, System Icon
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "openConfigDialog"), animated: true)
        
        // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "learning_center")!)
        
        // alternate right button, still not shown
        // let image = UIImage(named: "system20")
        // let barButtomItemC = UIBarButtonItem(image: image, style: .Plain, target: nil, action: nil)
        // navigationItem.rightBarButtonItem = barButtomItemC
        
    }
    
    func setLayout(myLayout: NSString) -> Void {
    
        var marginTop: CGFloat = 80
        
        if(myLayout.isEqualToString("landscape")) {
            
            marginTop = 40
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: marginTop, left: 20, bottom: 20, right: 20)
    
        let picDimensionX = self.view.frame.size.width / 2.5
        let picDimensionY = self.view.frame.size.height / 2.5
    
        layout.itemSize = CGSize(width: picDimensionX, height: picDimensionY)
    
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "learning_center")?.drawInRect(self.view.bounds)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.collectionView.backgroundColor = UIColor(patternImage: image)
        
        // self.collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "learning_center", d)!)
        
        self.view.addSubview(self.collectionView!)
    
    }
    
    func rotated()
    {
        // println("rotate")
            
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            // println("landscape")
            setLayout("landscape")
        }
        if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            // println("portrait")
            setLayout("portrait")
        }
        
    }
    
    
    // func orientationChanged(notification: NSNotification) {
    //
    // } ?
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return 20
        return menuItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as MyCollectionViewCell
        
        // cell.backgroundColor = UIColor.blackColor()
        // cell.textLabel?.text = "\(indexPath.section):\(indexPath.row)"
        // cell.imageView?.image = UIImage(named: "website")
        
        cell.setMenuItem(menuItems[indexPath.row])
        
        return cell
    }
    
    // Images as Buttons and Actions
    // 
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
        alert.addAction(alertAction)
        
        // self.presentViewController(alert, animated: true, completion: nil)
        
        
        switch(indexPath.item) {
        case 0: showWebView("website")
            break
        case 1: showWebView("primo")
            break
        case 2: let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NewsView") as FeedTableViewController
        self.navigationController?.pushViewController(homeViewController, animated: true)
            break
        case 3: let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SeatsView") as SeatsTableViewController
        self.navigationController?.pushViewController(homeViewController, animated: true)
            break
            
        default: println("default action")
        }
    }
    
    func showWebView(destination: String) {
        
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WebView") as WebViewController
        
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
        
        let tableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SeatsView") as TableViewController
        
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
    
    // Images as Buttons and actions END
    
    // Segue Perparation
    //
    
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
        
        if (segue.identifier == "showNews") {
            
            let destinationViewController = segue.destinationViewController as TableViewController
            destinationViewController.viewDidLoad()
            
        }
        
        if (segue.identifier == "showSeats") {
            
            let destinationViewController = segue.destinationViewController as ViewController
            destinationViewController.viewDidLoad()
            
        }
    }
    
    func openConfigDialog() {
        
    }
    
    // Segue Preparation END
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initMenuItems() {
        
        var items = [MenuItem]()
        
        let inputFile = NSBundle.mainBundle().pathForResource("items", ofType: "plist")
        
        let inputDataArray = NSArray(contentsOfFile: inputFile!)
        
        for inputItem in inputDataArray as [Dictionary<String, String>] {
            let menuItem = MenuItem(dataDictionary: inputItem)
            items.append(menuItem)
        }
        
        menuItems = items
    }

    
    
}