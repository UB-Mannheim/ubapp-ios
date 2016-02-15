//
//  WebViewController.swift
//  UBMannheimApp
//
//  Created by Alexander Wagner on 27.01.15,
//  modified on 11.02.16.
//
//  Copyright (c) 2015 Alexander Wagner, UB Mannheim. 
//  All rights reserved.
//
//
//  Toolbar Icons by Iconbeast
//  Source: http://www.iconbeast.com/free/
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var DEBUG: Bool = false
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    // Fallback URL (probably always reachable)
    var website:NSString = "http://www.google.de"
    
    let userDefaults:NSUserDefaults=NSUserDefaults.standardUserDefaults()
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setting Configuration Keys
        
        let kfirstrun: Int? = userDefaults.objectForKey("firstRun") as! Int?
        let kcache: Bool? = userDefaults.objectForKey("cacheEnabled") as! Bool?
        let knews: Int? = userDefaults.objectForKey("newsCount") as! Int?
        let kstartup: Int? = userDefaults.objectForKey("startupWith") as! Int?
        
        if (DEBUG) { print("DEBUG MSG WebViewController_ : FirstRun = \(kfirstrun) | Cache = \(kcache) | News = \(knews) | Startup \(kstartup)") }
        
        
        // Initializing Language String Dictionary
        let dict = appDelegate.dict
        
        
        // Setting title according to Website
        
        if(self.website.containsString("primo.bib.uni-mannheim.de")) {
            self.title = "Primo"
        }
        
        if(self.website.containsString("www.bib.uni-mannheim.de")) {
            self.title = "Website"
        }
        
        
        // Network Check
        
        if IJReachability.isConnectedToNetwork() {
        
            webView.loadRequest(NSURLRequest(URL: NSURL(string: self.website as String)!))
            webView.delegate = self
            
        } else {
            
            let offlineError: String = dict.objectForKey("urls")!.objectForKey("Offline") as! String
            let url = NSBundle.mainBundle().URLForResource(offlineError, withExtension:"html")
            
            let request = NSURLRequest(URL: url!)
            webView.loadRequest(request)
            webView.delegate = self
            
            let alertMsg_Err_noNetwork: String = dict.objectForKey("alertMessages")!.objectForKey("Website")!.objectForKey("noNetwork") as! String
            
            returnNetworkError(alertMsg_Err_noNetwork)
            
        }
        
        if (DEBUG) { print("didLoad") }

   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        if (DEBUG) { print("didReceiveMemoryWarning") }
    }
    
    
    /*
        // // // // // // // // // // // // // // // // // // // // // // // // //
    
        Circular ProgressBar (Upper right in NavigationBar)
    */
    
    // show circular progress activity in upper navigation bar
    // -start()
    //  call: self.webViewDidStartLoad(webView)
    
    func webViewDidStartLoad(webView: UIWebView) {
        // print("Webview started Loading")
        
        activity.hidden = false
        activity.startAnimating()
        
        // Activity Bar in Top Bar
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        let activityBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = activityBarButtonItem
        activityIndicator.startAnimating()
        
    }
    
    // show circular progress activity in upper navigation bar
    // -stop()
    //  call: self.webViewDidFinishLoad(webView)
    
    func webViewDidFinishLoad(webView: UIWebView) { //stop
        // print("Webview did finish load")
        
        activity.hidden = true
        activity.stopAnimating()
        
        navigationItem.rightBarButtonItem = nil
        
        let www_js:String = "document.getElementById('mobile_trailer').style.backgroundColor = 'white'; " +
        "document.getElementById('mobile_trailer').style.transition = 'background-color 1000ms linear'; "
        
        let primo_js:String = "document.getElementById('exlidUserAreaTile').style.padding = '10px'; " +
            "document.getElementById('logos').style.visibility = 'hidden'; " +
            "document.getElementById('exlidSearchTile').style.position = 'relative'; " +
            "document.getElementById('exlidSearchTile').style.top = '-80px'; " +
            "document.getElementById('exlidMainMenuRibbon').style.display = 'none'; " +
            "document.getElementById('exlidHeaderContainer').style.height = '100px'; "
            
            
        self.webView.stringByEvaluatingJavaScriptFromString(primo_js)
        
        self.webView.stringByEvaluatingJavaScriptFromString(www_js)
        
        if (DEBUG) { print("didFinishLoad") }
        
    }

    
    
    /*
        // // // // // // // // // // // // // // // // // // // // // // // // //
    
        UIWebView Delegate Functions, requirement: extend class with <UIWebViewDelegate>
    */
    
    // Webview Error Handling
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("Webview fail with error \(error)");
    }
    
    // Webview Request
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let dict = appDelegate.dict
        let alertMsg_Err_lostConnection: String = dict.objectForKey("alertMessages")!.objectForKey("Website")!.objectForKey("lostConnection") as! String
        
        
        if( (navigationType == UIWebViewNavigationType.LinkClicked) && (IJReachability.isConnectedToNetwork() == false) ) {
            if (DEBUG) { print("tapped") }
            
            returnNetworkError(alertMsg_Err_lostConnection)
            
        }
        
    return true;
    }
    
    
    // no more longer used
    
    
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animateWithDuration(duration) {
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
    }
    
    // end
    

    @IBAction func back(sender: UIBarButtonItem) {
        
        let dict = appDelegate.dict
        let alertMsg_Err_noNetwork: String = dict.objectForKey("alertMessages")!.objectForKey("Website")!.objectForKey("noNetwork") as! String
        
        if (IJReachability.isConnectedToNetwork()) {
            if (self.webView.canGoBack) {
                self.webView.goBack()
            }
        } else {
            
            returnNetworkError(alertMsg_Err_noNetwork)
        }
    }
    
    @IBAction func forward(sender: UIBarButtonItem) {
        
        let dict = appDelegate.dict
        let alertMsg_Err_noNetwork: String = dict.objectForKey("alertMessages")!.objectForKey("Website")!.objectForKey("noNetwork") as! String
        
        if (IJReachability.isConnectedToNetwork()) {
            if (self.webView.canGoForward) {
                self.webView.goForward()
            }
        } else {
            
            returnNetworkError(alertMsg_Err_noNetwork)
        }
    }
    
    
    // UI Bar Button Elements
    
    @IBAction func home(sender: UIBarButtonItem) {
        // self.webView.stopLoading()
        // let requestURL = NSURL(string: "http://www.bib.uni-mannheim.de/mobile")
        
        let dict = appDelegate.dict
        let primo_url: String = dict.objectForKey("urls")!.objectForKey("Primo") as! String
        let alertMsg_Err_noNetwork: String = dict.objectForKey("alertMessages")!.objectForKey("Website")!.objectForKey("noNetwork") as! String
        
        var homeStr = dict.objectForKey("urls")!.objectForKey("Website") as! String
        
        if(self.website.containsString("primo.bib.uni-mannheim.de")) {
            
            homeStr = primo_url
            
        }
        
        let requestURL = NSURL(string: homeStr)
        
        if (IJReachability.isConnectedToNetwork()) {
            let request = NSURLRequest(URL: requestURL!)
            self.webView.loadRequest(request)
        } else {
            
            returnNetworkError(alertMsg_Err_noNetwork)
        }
    }
    
    @IBAction func reload(sender: UIBarButtonItem) {
        
        let dict = appDelegate.dict
        let alertMsg_Err_noNetwork: String = dict.objectForKey("alertMessages")!.objectForKey("Website")!.objectForKey("noNetwork") as! String
        
        if (IJReachability.isConnectedToNetwork()) {
            self.webView.reload()
        } else {
            
            returnNetworkError(alertMsg_Err_noNetwork)
        }
    }
    
    func returnNetworkError(error_msg: String) {
        
        let dict = appDelegate.dict
        let alertMsg_Error: String = dict.objectForKey("alertMessages")!.objectForKey("errorTitle")! as! String
        let alertMsg_Back: String = dict.objectForKey("alertMessages")!.objectForKey("cancelAction")! as! String
        let alertMsg_Reload: String = dict.objectForKey("alertMessages")!.objectForKey("reloadAction")! as! String
        
        let alertController = UIAlertController(title: alertMsg_Error, message: error_msg, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: alertMsg_Back, style: .Cancel) { (action) in
            
            self.userDefaults.setObject(1, forKey: "backFromWebview")
            
            let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenu") as! MainMenuController
            self.navigationController?.pushViewController(homeViewController, animated: true)
            
        }
        
            let okAction = UIAlertAction(title: alertMsg_Reload, style: .Default) { (action) in
            self.viewDidLoad()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

