//
//  MainMenuController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 09.04.15.
//  Last modified on 23.03.2016
//
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
//
//

import UIKit

class MainMenuController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate, UIApplicationDelegate {

    var DEBUG: Bool = false
    // if (DEBUG) {}
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    var menuItems: [MenuItem] = []
    var redirect = false
    
    // Delete defaults Values
    var myArray : Array<Double>! {
        get {
            if let myArray: AnyObject! = NSUserDefaults.standardUserDefaults().objectForKey("myArray") {
                if (DEBUG) { print("\(myArray)") }
                return myArray as! Array<Double>!
            }
            
            return nil
        }
        set {
            if (DEBUG) { print(myArray) }
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "myArray")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    var preferredLanguage = NSLocale.preferredLanguages()[0] as String
    
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (DEBUG) { print("DEBUG MSG MainMenuController : System starting ...") }
        
        let kfirstrun: Int? = userDefaults.objectForKey("firstRun") as! Int?
        let wback: Int? = userDefaults.objectForKey("backFromWebview") as! Int?
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        // Simple redirection if Startup option ist chosen
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        
        if (DEBUG) {
            print("DEBUG MSG MainMenuController : FirstRun = \(kfirstrun) | backFromWebview = \(wback) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup)")
        }
        
        // Now startup with selected Module
        if ((kstartup != nil) && (kstartup != 0)) {
            
            // If online
            if (IJReachability.isConnectedToNetwork()) {
                redirect = true
                
            // If offline
            } else {
                // www || primo (webview)
                if((kstartup == 1) || (kstartup == 2)) {
                    redirect = false
                
                // news || freie plaetze
                } else {
                    if (kcache == true) { // && (knews > 0)) { // enabled ja ... Check: aber auch gefuellt? // count news != 0
                        redirect = true
                        if (DEBUG) { print("redir true") }
                        
                    } else {
                        redirect = false
                        if (DEBUG) { print("redir false") }
                        
                        if(wback != 1) {
                            
                            // Set Marker for unique Display at Start without internet and cache
                            userDefaults.setObject(1, forKey: "backFromWebview")
                     
                            let dict = appDelegate.dict;
                            
                            let alertMsg_Error: String = dict.objectForKey("alertMessages")!.objectForKey("errorTitle")! as! String
                            let alertMsg_Ok: String = dict.objectForKey("alertMessages")!.objectForKey("okAction")! as! String
                            let redirectError: String = dict.objectForKey("alertMessages")!.objectForKey("MainMenu")!.objectForKey("noRedirect") as! String
                            let alertController = UIAlertController(title: alertMsg_Error, message: redirectError, preferredStyle: .Alert)
                     
                            let okAction = UIAlertAction(title: alertMsg_Ok, style: .Default) { (action) in
                                self.viewDidLoad()
                            }
                        
                            alertController.addAction(okAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        
                    }
                    
                }
            }
            
            if (redirect == true) {
                
                // iIf not set back because of coming back from webview (offline)
                if (wback != 1) {
                    // select action and following controller
                    if(kstartup == 1) { showWebView("website") }
                    if(kstartup == 2) { showWebView("primo") }
                    if(kstartup == 3) { showNews() }
                    if(kstartup == 4) { showSeats() }
                
                    // if online again an not back from webview
                } else {
                    userDefaults.setObject(0, forKey: "backFromWebview")
                }
            }
            
        }
    
        initMenuItems()
        
        init_preferences()
        
        if (DEBUG) {
            print("Configuration States: ")
            print("firstRun :: ")
            print(userDefaults.objectForKey("firstRun"))
            print("cacheEnabled :: ")
            print(userDefaults.objectForKey("cacheEnabled"))
            print("startupWith :: ")
            print(userDefaults.objectForKey("startupWith"))
            print("newsCount :: ")
            print(userDefaults.objectForKey("newsCount"))
        }
        
        if (DEBUG) { print("DEBUG MSG MainMenuController : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup)") }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        rotated()
        
        // FixMe: No more longer needed?
        // collectionView.reloadData()
        
    }

    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None // Alternative values: .FullScreen, .OverFullScreen
    }
    
    func presentationController(controller: UIPresentationController,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
            return UINavigationController(rootViewController: controller.presentedViewController)
    }
    
    // FixMe: No more longer needed?
    @IBAction func popOut_(sender: UIView) {
        print("POPOut deactivated")
    }
    
    // FixMe: No more longer needed?
    func popOut(sender: UIView) {
        print("POPOut deactivated")
    }
    
    // FixMe: No more longer needed?
    func popOutProg(sender: UIBarButtonItem) {
        // popover.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: .Any, animated: true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        var nav = self.navigationController?.navigationBar
        
        let barButtomItem = UIBarButtonItem(image: UIImage(named: "bar_button"), style: .Plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = barButtomItem
        
        // Back Button in Child-View pressed, action if back to main Menu
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        rotated()
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
        
        if( UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) ) {
            
            //Portrait orientation
            if (DEBUG) { print("portrait") }
            setLayout("portrait")
        }
        
        if( UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) ) {
            
            //Landscape orientation
            if (DEBUG) { print("landscape") }
            setLayout("landscape")
        }
        
    }
    
    // Images as Buttons and actions
    //

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return 20
        return menuItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! MyCollectionViewCell
        cell.setMenuItem(menuItems[indexPath.row])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
        alert.addAction(alertAction)
        
        switch(indexPath.item) {
            case 0: showWebView("website")
                break
            case 1: showWebView("primo")
                break
            case 2: let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NewsView") as! FeedTableViewController
                self.navigationController?.pushViewController(homeViewController, animated: true)
                break
            case 3: let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SeatsView") as! SeatsTableViewController
                self.navigationController?.pushViewController(homeViewController, animated: true)
                break
            
            default: print("default action")
        }
    }
    
    func showWebView(destination: String) {
        
        var path = NSBundle.mainBundle().pathForResource("strings", ofType: "plist")
        
        if (preferredLanguage.containsString("de-")) {
            path = NSBundle.mainBundle().pathForResource("strings_de", ofType: "plist")
        }
        
        if (DEBUG) { print(preferredLanguage) }
        
        // Initialize Dictionary
        let dict = NSDictionary(contentsOfFile: path!)
        
        // Menu Actions for Webview
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WebView") as! WebViewController
        
        // var url: NSString = ""
        var url: AnyObject = []
        
        if (destination=="website") {
            // url = "http://www.bib.uni-mannheim.de/mobile"
            url = dict!.objectForKey("urls")!.objectForKey("Website")!
        }

        
        if (destination=="primo") {
            // url = "http://primo.bib.uni-mannheim.de/primo_library/libweb/action/search.do?vid=MAN_MOBILE"
            url = dict!.objectForKey("urls")!.objectForKey("Primo")!
            
            // Demo from IGeLU
            // url = "test.url"
        }
        
        webViewController.website = url as! NSString
        
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func showSeats() {
        
        let tableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SeatsView") as! SeatsTableViewController
        
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    func showNews() {
        
        let tableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NewsView") as! FeedTableViewController
        
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    func showSubMenu() {
        
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("SubMenuView") as! ViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //
    // Images as Buttons and actions
    
    
    // Segue Perparation
    //
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "showWebsite") {
            
            let destinationViewController = segue.destinationViewController as! WebViewController
            var website:NSString = ""
            website = "http://www.bib.uni-mannheim.de/mobile"
            destinationViewController.website = website
            
        }
        
        if (segue.identifier == "showPrimo") {
            
            let destinationViewController = segue.destinationViewController as! WebViewController
            var website:NSString = ""
            website = "http://primo.bib.uni-mannheim.de/primo_library/libweb/action/search.do?vid=MAN_MOBILE"
            destinationViewController.website = website
            
        }
        
        if (segue.identifier == "showNews") {
            
            let destinationViewController = segue.destinationViewController as! TableViewController
            destinationViewController.viewDidLoad()
            
        }
        
        if (segue.identifier == "showSeats") {
            
            let destinationViewController = segue.destinationViewController as! ViewController
            destinationViewController.viewDidLoad()
            
        }
    }
    
    //
    // Segue Preparation
        
    func openConfigDialog() {
        if (DEBUG) { print("opened") }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initMenuItems() {
        
        var items = [MenuItem]()
        var inputFile = NSBundle.mainBundle().pathForResource("items", ofType: "plist")
        
        if (preferredLanguage.containsString("de-")) {
                
            inputFile = NSBundle.mainBundle().pathForResource("items_de", ofType: "plist")
        }
        
        let inputDataArray = NSArray(contentsOfFile: inputFile!)
        
        for inputItem in inputDataArray as! [Dictionary<String, String>] {
            let menuItem = MenuItem(dataDictionary: inputItem)
            items.append(menuItem)
        }
        
        menuItems = items
    }
    
    func init_preferences() {
        
        var cacheReference: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        if (cacheReference == nil) {
            cacheReference = false
        } else {
            cacheReference = userDefaults.objectForKey("cacheEnabled") as! Bool?
        }
        
        var startupReference: Int? = userDefaults.objectForKey("startupWith") as! Int?
        if (startupReference == nil) {
            startupReference = 0
        } else {
            startupReference = userDefaults.objectForKey("startupWith") as! Int?
        }
        
        var newsReference: Int? = userDefaults.objectForKey("newsCount") as! Int?
        if (newsReference == nil) {
            newsReference = 5
        } else {
            newsReference = userDefaults.objectForKey("newsCount") as! Int?
        }
        
        userDefaults.setObject(cacheReference, forKey: "cacheEnabled")
        userDefaults.setObject(startupReference, forKey: "startupWith")
        userDefaults.setObject(newsReference, forKey: "newsCount")
        userDefaults.synchronize()
    }
    
}