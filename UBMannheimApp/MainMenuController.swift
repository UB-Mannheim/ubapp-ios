//
//  MainMenuController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 09.04.15.
//  Copyright (c) 2015 Alexander Wagner. All rights reserved.
// 
//  Hard Coded Bundle Identifier 
//  $(PRODUCT_NAME:rfc1034identifier) -> app
//  http://stackoverflow.com/questions/28118970/xcode-6-how-to-set-a-custom-bundle-identifier
//
//

import UIKit

class MainMenuController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate, UIApplicationDelegate {

    var DEBUG: Bool = false
    // if (DEBUG) {
    
    // exkurs: tutorial adaptive layout
    // https://youtu.be/E3glNbNnokw
    
    
    // this.
    // http://www.brianjcoleman.com/tutorial-collection-view-using-swift/
    
    @IBOutlet var collectionView: UICollectionView!
    
    var menuItems: [MenuItem] = []
    var redirect = false
    
    // Defaults loeschen
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
    
    /*
    var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var picDimensionX: CGFloat = 0.0
    var picDimensionY: CGFloat = 0.0
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (DEBUG) { print("DEBUG MSG MainMenuController : System starting ...") }
        
        let kfirstrun: Int? = userDefaults.objectForKey("firstRun") as! Int?
        // let wback: Int? = userDefaults.objectForKey("backFromWebView") as! Int?
        let wback: Int? = userDefaults.objectForKey("backFromWebview") as! Int?
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        if (DEBUG) { print("DEBUG MSG MainMenuController : FirstRun = \(kfirstrun) | backFromWebview = \(wback) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup)") }
        
        // simple redirection if startup option ist chosen
        // let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int? >> s.o.
        
        // startupWith selected module
        if ((kstartup != nil) && (kstartup != 0)) {
            
            // online
            if (IJReachability.isConnectedToNetwork()) {
                redirect = true
                
            // offline
            } else {
                // www || primo (webview)
                if((kstartup == 1) || (kstartup == 2)) {
                    redirect = false
                
                // news || freie plaetze
                } else {
                    if (kcache == true) { // && (knews > 0)) { // enabled ja ... aber auch gefuellt? // count news != 0
                        redirect = true
                        
                        if (DEBUG) { /* print("A") */ }
                        //
                    } else {
                        
                        if (DEBUG) { /* print("B") */ }
                        /*
                        // wenn cache aus eigentlich nicht weiterleiten
                        if ((kstartup == 1) || (kstartup == 2)) {
                            redirect = false
                        // aber im falle von news || freie platze schon?
                        } else {
                            redirect = true
                        }
                        */
                        
                        // oder mit Ausgabe: keine Weiterleitung möglich, da keine Offline Inhalte vorhanden
                        redirect = false
                        
                        // hinweis: Weiterleitung nicht möglich // ggf  var:firstRun nutzen
                        if(wback != 1) {
                            
                            // marker setzen zur einmaligen anzeige bei start ohne internet und cache
                            userDefaults.setObject(1, forKey: "backFromWebview")
                        
                            let alertController = UIAlertController(title: "Fehler", message: "Weiterleitung zum ausgewählten Startmodul nicht möglich. Es stehen weder eine Internetverbindung, noch Offline Inhalte zur Verfügung. Bitte stellen Sie zur Nutzung der App eine Verbindung zum Internet her.", preferredStyle: .Alert)
                     
                            let okAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                                self.viewDidLoad()
                            }
                        
                            alertController.addAction(okAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                        
                    }
                    
                }
            }
            
            if (redirect == true) {
                
                // if not set back because of coming back from webview (offline)
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
            
            /*
            if(wback != 1) {
                // check "firstRun" of Apllication to avoid loops
                if(userDefaults.objectForKey("firstRun")?.integerValue == 1) {
            
                    // select action and following controller
                    if(kstartup == 1) { showWebView("website") }
                    if(kstartup == 2) { showWebView("primo") }
                    if(kstartup == 3) { showNews() }
                    if(kstartup == 4) { showSeats() }
                }
            } else {
                // when application returns from webview (no network), forwarding to custom module is off
                // -> if webview before selected as startmodule, this would produce a loop
                // if connectivity check now returns true, variable is overwritten and forwarding ok
                if IJReachability.isConnectedToNetwork() {
                    // userDefaults.setObject(0, forKey: "backFromWebView")
                    userDefaults.setObject(0, forKey: "backFromWebview")
                    userDefaults.synchronize()
                    
                    if(userDefaults.objectForKey("firstRun")?.integerValue == 1) {
                        
                        // select action and following controller
                        if(kstartup == 1) { showWebView("website") }
                        if(kstartup == 2) { showWebView("primo") }
                        if(kstartup == 3) { showNews() }
                        if(kstartup == 4) { showSeats() }
                    }
                }
                
            }
            */
            
            /*
            var redir = true
            // if newtork off && cache off
            if ((IJReachability.isConnectedToNetwork() != false) && (kcache == false)) {
                redir = false
            }
            
            if(redir != false) {
            // redirect
            // select action and following controller
                if(kstartup == 1) { showWebView("website") }
                if(kstartup == 2) { showWebView("primo") }
                if(kstartup == 3) { showNews() }
                if(kstartup == 4) { showSeats() }
            }
            */
            
            // old way
            // let startController = self.storyboard!.instantiateViewControllerWithIdentifier("ConfigView") as! ConfigController
            // self.navigationController!.pushViewController(startController, animated: true)
        }
    
        initMenuItems()
        
        init_preferences()
        
        /*
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
        */
        
                if (DEBUG) { print("DEBUG MSG MainMenuController : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup)") }
        
        
        // init toolbar (hidden in storyboard)
        // self.tabBarController?.tabBar.hidden = true
        
        
        /*
        var currentDevice: UIDevice = UIDevice.currentDevice()
        var orientation: UIDeviceOrientation = currentDevice.orientation
        print(orientation)
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
        
        // popover menu
        // http://gracefullycoded.com/display-a-popover-in-swift/
        // created popover, with/without according view in storyboard
        
        //alternate
        // https://www.shinobicontrols.com/blog/posts/2014/08/26/ios8-day-by-day-day-21-alerts-and-popovers
        // https://github.com/ShinobiControls/iOS8-day-by-day/tree/master/21-alerts-and-popovers/AppAlert/AppAlert
        
        
    }

    // popover trial wenderlich
    //
    // http://www.raywenderlich.com/forums/viewtopic.php?f=20&t=19908&start=50s
    
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None // .FullScreen, .OverFullScreen
    }
    
    func presentationController(controller: UIPresentationController,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
            return UINavigationController(rootViewController: controller.presentedViewController)
    }
    
    // standard
    @IBAction func popOut_(sender: UIView) {
        // https://www.shinobicontrols.com/blog/posts/2014/08/26/ios8-day-by-day-day-21-alerts-and-popovers
    
    print("POPOut deactivated")
/*

Deactivate PopOverController, cause there are problems in Swift 2 and Controller is not used

        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("PopoverController") as UIViewController
            popoverVC.modalPresentationStyle = .Popover
            popoverVC.preferredContentSize = CGSizeMake(200,100)
        
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
        }
        
        presentViewController(popoverVC, animated: true, completion: nil)
*/
    }
    
    // middle of screen, linked to navbar
    func popOut(sender: UIView) {
        
    print("POPOut deactivated")

/*

Deactivate PopOverController, cause there are problems in Swift 2 and Controller is not used

        // http://stackoverflow.com/questions/24635744/how-to-present-popover-properly-in-ios-8
    
        var popoverContent = storyboard?.instantiateViewControllerWithIdentifier("PopoverController") as UIViewController
            popoverContent.preferredContentSize = CGSizeMake(200,100)
        
        var nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        var popover = nav.popoverPresentationController
            popoverContent.preferredContentSize = CGSizeMake(500,600)
            popover!.delegate = self
            popover!.sourceView = self.view
            popover!.sourceRect = CGRectMake(100,100,360,0)
    
        self.presentViewController(nav, animated: true, completion: nil)
*/
    }
    
    func popOutProg(sender: UIBarButtonItem) {
        // popover.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: .Any, animated: true)
        
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
        
        // right Navigation Item, SystemButton
        // self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "openConfigDialog"), animated: true)
        
        /*
        // right Navigation Item as UIButton Btn_DotMore_iconbeast
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(image: UIImage(named: "Btn_DotMore_iconbeast"), style: .Plain, target: self, action: "popOutProg"), animated: true)
        */

        // set of icons
        // http://iostechsolutions.blogspot.de/2014/11/swift-add-custom-right-bar-button-item.html
        // self.navigationItem.setLeftBarButtonItems(<#items: [AnyObject]?#>, animated: <#Bool#>)
        
        // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "learning_center")!)
        
        // alternate right button, still not shown
        // let image = UIImage(named: "system20")
        // let barButtomItemC = UIBarButtonItem(image: image, style: .Plain, target: nil, action: nil)
        // navigationItem.rightBarButtonItem = barButtomItemC
        
        // initMenuItems()
        
        
        // trying to connect the popover view to main view, to get navigation controllers
        /*
        let vc_help : UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HelpView") as! UIViewController;
        self.presentViewController(vc_help, animated: true, completion: nil)
        
        let vc_conf : UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ConfigView") as! UIViewController;
        self.presentViewController(vc_conf, animated: true, completion: nil)
        */
        
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
        // urspruenglich wurde die orientierung ueber das geraet bestimmt
        // das fuehrte allerdings dazu dass bei waagrechter haltung keine 
        // gueltige orientierung bestimmt werden konnte
        // daher wird im else zweig (not valid) die orientierung der status 
        // bar benutzt
        
        // print("rotate")
        
        /*
        if (UIDeviceOrientationIsValidInterfaceOrientation(UIDevice.currentDevice().orientation)) {
        print("valid orientation")
            
            if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
            {
                print("landscape")
                setLayout("landscape")
            }
            else if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
            {
                print("portrait")
                setLayout("portrait")
            }
            else {
                print("something different")
            
            }
            
        } else {
            print("no valid orientation")
            // hack: decide orientation by status bar
            // http://stackoverflow.com/questions/25796545/getting-device-orientation-in-swift
            
            // UIInterfaceOrientation orientation = UIApplication.sharedApplication().statusBarOrientation
            
            if( UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation) ) {
                    
                //Portrait orientation
                print("portrait alt")
                setLayout("portrait")
            }
            
            if( UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) ) {
                    
                //Landscape orientation
                print("landscape alt")
                setLayout("landscape")
            }
        
        }
        */
        
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! MyCollectionViewCell
        
        // cell.backgroundColor = UIColor.blackColor()
        // cell.textLabel?.text = "\(indexPath.section):\(indexPath.row)"
        // cell.imageView?.image = UIImage(named: "website")
        
        cell.setMenuItem(menuItems[indexPath.row])
        
        return cell
    }
    
    // Images as Buttons and Actions
    // 
    // LATEST MENU ACTIONS ...
    // 
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
        alert.addAction(alertAction)
        
        // self.presentViewController(alert, animated: true, completion: nil)
        
        // as in webview controller - is it better using available controllers?
        // http://stackoverflow.com/questions/29993085/ios-swift-returning-to-the-same-instance-of-a-view-controller
            
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
        
        let webViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WebView") as! WebViewController
        
        var url: NSString = ""
        
        if (destination=="website") {
            url = "http://www.bib.uni-mannheim.de/mobile"
        }
        
        if (destination=="primo") {
            url = "http://primo.bib.uni-mannheim.de/primo_library/libweb/action/search.do?vid=MAN_MOBILE"
            // url = "http://primo-demo.exlibrisgroup.com:1701/primo-explore2/"
        }
        
        webViewController.website = url
        
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
    
    // Segue Preparation END
        
    func openConfigDialog() {
        if (DEBUG) { print("opened") }
    }
    
    /*
    @IBAction func openPopover(sender: UIBarButtonItem){
    // http://makeapppie.com/2014/08/30/the-swift-swift-tutorials-adding-modal-views-and-popovers/
    //performSegueWithIdentifier("Popover", sender: self)
        let vc = storyboard?.instantiateViewControllerWithIdentifier("PopoverViewController") as UIViewController
        vc.modalPresentationStyle = .Popover
        let aPopover =  UIPopoverController(contentViewController: vc)
        aPopover.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: .Any, animated: true)
    }
    */
    
    // lldb
    /*
    @IBAction func handlePopoverPressed(sender: AnyObject) {
        let button = sender as! UIBarButtonItem
        let tableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PopoverViewController")! as! TableViewController
        let popover = UIPopoverController(contentViewController: tableViewController)
        popover.presentPopoverFromBarButtonItem(button, permittedArrowDirections: .Any, animated: true)
    }
    */

    // unrecognized selector
    /*
    @IBAction func handlePopoverPressed(sender: UIView) {
        
        /*
        let storyboard : UIStoryboard = UIStoryboard(
        name: "Main",
        bundle: nil)
        */
        
        let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("PopoverController") as! UIViewController
        popoverVC.modalPresentationStyle = .Popover
        popoverVC.preferredContentSize = CGSizeMake(200,100)
        
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
            popoverController.permittedArrowDirections = .Any
            popoverController.delegate = self
        }
        presentViewController(popoverVC, animated: true, completion: nil)
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initMenuItems() {
        
        var items = [MenuItem]()
        
        var inputFile = NSBundle.mainBundle().pathForResource("items", ofType: "plist")
        
        if (preferredLanguage == "de") {
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