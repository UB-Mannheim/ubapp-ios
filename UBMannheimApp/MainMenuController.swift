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
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    var menuItems: [MenuItem] = []
    var redirect = false
    
    // Delete defaults Values
    var myArray : Array<Double>! {
        get {
        /*    if let myArray: AnyObject UserDefaults.standard.object(forKey: "myArray") as AnyObject {
                if (DEBUG) { print("\(String(describing: myArray))") }
                return myArray as! Array<Double>!
            }
        */
            return nil
        }
        set {
            // emtpy Array, look above
            if (DEBUG) { print(myArray) }
            UserDefaults.standard.set(newValue, forKey: "myArray")
            UserDefaults.standard.synchronize()
        }
    }

    var preferredLanguage = Locale.preferredLanguages[0] as String
    
    let userDefaults:UserDefaults=UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (DEBUG) { print("DEBUG MSG MainMenuController : System starting ...") }
        
        let kfirstrun: Int? = userDefaults.object(forKey: "firstRun") as! Int?
        let wback: Int? = userDefaults.object(forKey: "backFromWebview") as! Int?
        let kcache: Bool? = userDefaults.object(forKey: "cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.object(forKey: "newsCount") as! Int?
        // Simple redirection if Startup option ist chosen
        let kstartup: Int? = userDefaults.object(forKey: "startupWith") as! Int?
        
        if (DEBUG) {
            print("DEBUG MSG MainMenuController : FirstRun = \(String(describing: kfirstrun)) | backFromWebview = \(String(describing: wback)) | Cache = \(String(describing: kcache)) | News = \(String(describing: knews)) | Startup \(String(describing: kstartup))")
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
                            userDefaults.set(1, forKey: "backFromWebview")
                     
                            let dict = appDelegate.dict;
                            
                            let alertMsg_Error: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "errorTitle")! as! String
                            let alertMsg_Ok: String = (dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "okAction")! as! String
                            let redirectError: String = ((dict.object(forKey: "alertMessages")! as AnyObject).object(forKey: "MainMenu")! as AnyObject).object(forKey: "noRedirect") as! String
                            let alertController = UIAlertController(title: alertMsg_Error, message: redirectError, preferredStyle: .alert)
                     
                            let okAction = UIAlertAction(title: alertMsg_Ok, style: .default) { (action) in
                                self.viewDidLoad()
                            }
                        
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
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
                    userDefaults.set(0, forKey: "backFromWebview")
                }
            }
            
        }
    
        initMenuItems()
        
        init_preferences()
        
        if (DEBUG) {
            print("Configuration States: ")
            print("stopped because of swift 3 tests")
            /*
            print("firstRun :: ")
            print(userDefaults.object(forKey: "firstRun") ?? <#default value#>)
            print("cacheEnabled :: ")
            print(userDefaults.object(forKey: "cacheEnabled") ?? <#default value#>)
            print("startupWith :: ")
            print(userDefaults.object(forKey: "startupWith") ?? <#default value#>)
            print("newsCount :: ")
            print(userDefaults.object(forKey: "newsCount") ?? <#default value#>)
             */
        }
        
        if (DEBUG) { print("DEBUG MSG MainMenuController : FirstRun = \(String(describing: kfirstrun)) | Cache = \(String(describing: kcache)) | News = \(String(describing: knews)) | Startup \(String(describing: kstartup))") }
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainMenuController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        rotated()
        
        // FixMe: No more longer needed?
        // collectionView.reloadData()
        
    }

    func adaptivePresentationStyle(
        for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none // Alternative values: .FullScreen, .OverFullScreen
    }
    
    func presentationController(_ controller: UIPresentationController,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
            return UINavigationController(rootViewController: controller.presentedViewController)
    }
    
    // FixMe: No more longer needed?
    @IBAction func popOut_(_ sender: UIView) {
        print("POPOut deactivated")
    }
    
    // FixMe: No more longer needed?
    func popOut(_ sender: UIView) {
        print("POPOut deactivated")
    }
    
    // FixMe: No more longer needed?
    func popOutProg(_ sender: UIBarButtonItem) {
        // popover.presentPopoverFromBarButtonItem(sender, permittedArrowDirections: .Any, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        _ = self.navigationController?.navigationBar
        
        let barButtomItem = UIBarButtonItem(image: UIImage(named: "bar_button"), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = barButtomItem
        
        // Back Button in Child-View pressed, action if back to main Menu
        NotificationCenter.default.addObserver(self, selector: #selector(MainMenuController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        rotated()
    }
    
    func setLayout(_ myLayout: NSString) -> Void {
    
        var marginTop: CGFloat = 80
        
        if(myLayout.isEqual(to: "landscape")) {
            
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
        self.collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "learning_center")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.collectionView.backgroundColor = UIColor(patternImage: image)
        // self.collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "learning_center", d)!)
        
        self.view.addSubview(self.collectionView!)
    
    }
    
    func rotated()
    {
        
        if( UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) ) {
            
            //Portrait orientation
            if (DEBUG) { print("portrait") }
            setLayout("portrait")
        }
        
        if( UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) ) {
            
            //Landscape orientation
            if (DEBUG) { print("landscape") }
            setLayout("landscape")
        }
        
    }
    
    // Images as Buttons and actions
    //

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return 20
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! MyCollectionViewCell
        cell.setMenuItem(menuItems[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
        alert.addAction(alertAction)
        
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
        
        var path = Bundle.main.path(forResource: "strings", ofType: "plist")
        
        if (preferredLanguage.contains("de-")) {
            path = Bundle.main.path(forResource: "strings_de", ofType: "plist")
        }
        
        if (DEBUG) { print(preferredLanguage) }
        
        // Initialize Dictionary
        let dict = NSDictionary(contentsOfFile: path!)
        
        // Menu Actions for Webview
        let webViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebView") as! WebViewController
        
        // var url: NSString = ""
        var url: NSString = ""
        
        if (destination=="website") {
            // url = "http://www.bib.uni-mannheim.de/mobile"
            // ?cannot fix
            url = ((dict!.object(forKey: "urls")! as AnyObject).object(forKey: "Website")! as AnyObject) as! NSString
        }

        
        if (destination=="primo") {
            // url = "http://primo.bib.uni-mannheim.de/primo_library/libweb/action/search.do?vid=MAN_MOBILE"
            url = "https://primo-49man.hosted.exlibrisgroup.com/primo-explore/search?sortby=rank&vid=MAN_UB&lang=de_DE"
            // ?cannot fix
            // url = ((dict!.object(forKey: "urls")! as AnyObject).object(forKey: "Primo")! as AnyObject)
            // Demo from IGeLU
            // url = "test.url"
        }
        
        webViewController.website = url 
        
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func showSeats() {
        
        let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SeatsView") as! SeatsTableViewController
        
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    func showNews() {
        
        let tableViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewsView") as! FeedTableViewController
        
        self.navigationController?.pushViewController(tableViewController, animated: true)
    }
    
    func showSubMenu() {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SubMenuView") as! ViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //
    // Images as Buttons and actions
    
    
    // Segue Perparation
    //
    
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
            // website = "http://primo.bib.uni-mannheim.de/primo_library/libweb/action/search.do?vid=MAN_MOBILE"
            website = "https://primo-49man.hosted.exlibrisgroup.com/primo-explore/search?sortby=rank&vid=MAN_UB&lang=de_DE"
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
    
    //
    // Segue Preparation
        
    func openConfigDialog() {
        if (DEBUG) { print("opened") }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func initMenuItems() {
        
        var items = [MenuItem]()
        var inputFile = Bundle.main.path(forResource: "items", ofType: "plist")
        
        if (preferredLanguage.contains("de-")) {
                
            inputFile = Bundle.main.path(forResource: "items_de", ofType: "plist")
        }
        
        let inputDataArray = NSArray(contentsOfFile: inputFile!)
        
        for inputItem in inputDataArray as! [Dictionary<String, String>] {
            let menuItem = MenuItem(dataDictionary: inputItem)
            items.append(menuItem)
        }
        
        menuItems = items
    }
    
    func init_preferences() {
        
        var cacheReference: Bool? = userDefaults.object(forKey: "cacheEnabled") as! Bool?
        if (cacheReference == nil) {
            cacheReference = false
        } else {
            cacheReference = userDefaults.object(forKey: "cacheEnabled") as! Bool?
        }
        
        var startupReference: Int? = userDefaults.object(forKey: "startupWith") as! Int?
        if (startupReference == nil) {
            startupReference = 0
        } else {
            startupReference = userDefaults.object(forKey: "startupWith") as! Int?
        }
        
        var newsReference: Int? = userDefaults.object(forKey: "newsCount") as! Int?
        if (newsReference == nil) {
            newsReference = 5
        } else {
            newsReference = userDefaults.object(forKey: "newsCount") as! Int?
        }
        
        userDefaults.set(cacheReference, forKey: "cacheEnabled")
        userDefaults.set(startupReference, forKey: "startupWith")
        userDefaults.set(newsReference, forKey: "newsCount")
        userDefaults.synchronize()
    }
    
}
